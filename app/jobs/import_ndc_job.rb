require 'zip'
#run rake import:ndc to invoke this.
class ImportNdcJob < ActiveJob::Base
  queue_as :default

  #perform import NDC data job
  def perform(chunk_size = 1000)

    @chunk_size = chunk_size.to_i

    @data_folder_path       = "/home/app/xenapi/db/data"
    ndc_zip_file            = "ndc.zip"
    ndc_products_file       = "product.txt"
    ndc_packages_file       = "package.txt"
    product_temp_file       = "#{@data_folder_path}/tmp/product.txt"
    package_temp_file       = "#{@data_folder_path}/tmp/package.txt"

    #clean up data import staging tables
    ActiveRecord::Base.connection.execute('truncate data_import_ndc_products;')
    ActiveRecord::Base.connection.execute('truncate data_import_ndc_packages;')

    #unzip to temp data tables
    unzip_it(ndc_zip_file, ndc_products_file, @data_folder_path)
    unzip_it(ndc_zip_file, ndc_packages_file, @data_folder_path)

    #chunk and then load into staging tables
    load_and_import("ndc_product", product_temp_file, product_headers) do
      |new_file, headers|
      import_product_data(new_file, headers)
    end

    load_and_import("ndc_package", package_temp_file, package_headers) do
      |new_file, headers|
      import_package_data(new_file, headers)
    end

    #append to domain tables for any new records
    append_clean_data

    #clean up
    cleanup_temp_files
  end

  def append_clean_data
    #append ndc_products data
    ActiveRecord::Base.connection.execute('
      INSERT INTO ndc_products (
            product_id,
            product_ndc,
            product_type_name,
            proprietary_name,
            proprietary_name_suffix,
            nonproprietary_name,
            dosage_form_name,
            route_name,
            start_marketing_date,
            end_marketing_date,
            marketing_category_name,
            application_number,
            label_name,
            substance_name,
            active_numerator_strength,
            active_ingred_unit,
            pharm_classes,
            dea_schedule
      )
      SELECT i."PRODUCTID",
        substring(leading_digits from length(leading_digits) - 4) || \'-\'     --digits leading to -
        || substring(last_4 from length(last_4) - 3),    --last 4
            i."PRODUCTTYPENAME",
            i."PROPRIETARYNAME",
            i."PROPRIETARYNAMESUFFIX",
            i."NONPROPRIETARYNAME",
            i."DOSAGEFORMNAME",
            i."ROUTENAME",
            to_date(i."STARTMARKETINGDATE", \'YYYYMMDD\'),
            to_date(i."ENDMARKETINGDATE", \'YYYYMMDD\'),
            i."MARKETINGCATEGORYNAME",
            i."APPLICATIONNUMBER",
            i."LABELERNAME",
            i."SUBSTANCENAME",
            i."ACTIVE_NUMERATOR_STRENGTH",
            i."ACTIVE_INGRED_UNIT",
            i."PHARM_CLASSES",
            i."DEASCHEDULE"
      FROM (  SELECT *
          , \'0000\' || substring("PRODUCTNDC" from 0 for position(\'-\' in "PRODUCTNDC")) AS leading_digits
          , \'000\' || substring("PRODUCTNDC" from position(\'-\' in "PRODUCTNDC") + 1 for 4) AS last_4
        FROM data_import_ndc_products) i
      LEFT JOIN ndc_products p
        ON i."PRODUCTID" = p.product_id
      WHERE p.product_id IS NULL;')

    ActiveRecord::Base.connection.execute('
      INSERT INTO ndc_packages(ndc_product_id, ndc_product_code, ndc_package_code, fda_native_code, description)
      SELECT
            p.id,
            p.product_ndc,
            p.product_ndc || \'-\' || i.last_2,
            i."NDCPACKAGECODE",
            i."PACKAGEDESCRIPTION"
      FROM (  SELECT *
            , replace(substring("NDCPACKAGECODE" from length("NDCPACKAGECODE") - 1), \'-\', \'0\') AS last_2
        FROM data_import_ndc_packages) i
      JOIN ndc_products p
        ON i."PRODUCTID" = p.product_id
      LEFT JOIN ndc_packages pck
        ON pck.ndc_package_code = p.product_ndc || \'-\' || i.last_2
          AND pck.ndc_product_id = p.id   --ndc not unique
      WHERE pck.ndc_package_code IS NULL
      ')
  end

  def import_package_data(filename, headers)
    table_data = []

    File.open(filename, "r") do
      |file|
      file.each_line do
        |line|
        row = {}
        line.chomp.split("\t").each_with_index do
          |value, i|
          value = value.gsub(/^"/, '').chomp('"')
          row[headers[i]] = value if (value && value != "")
        end
        table_data.push(
          [
            row[:PRODUCTID],
            row[:PRODUCTNDC],
            row[:NDCPACKAGECODE],
            row[:PACKAGEDESCRIPTION]
          ])
      end
    end

    if (table_data.length > 0)
      DataImportNdcPackage.import headers, table_data, validate: false
    end
  end

  def import_product_data(filename, headers)
    table_data = []

    File.open(filename, "r") do
      |file|
      file.each_line do
        |line|
        row = {}
        line.chomp.split("\t").each_with_index do
          |value, i|
          value = value.gsub(/^"/, '').chomp('"')
          row[headers[i]] = value if (value && value != "")
        end
        table_data.push(
          [
            row[:PRODUCTID],
            row[:PRODUCTNDC],
            row[:PRODUCTTYPENAME],
            row[:PROPRIETARYNAME],
            row[:PROPRIETARYNAMESUFFIX],
            row[:NONPROPRIETARYNAME],
            row[:DOSAGEFORMNAME],
            row[:ROUTENAME],
            row[:STARTMARKETINGDATE],
            row[:ENDMARKETINGDATE],
            row[:MARKETINGCATEGORYNAME],
            row[:APPLICATIONNUMBER],
            row[:LABELERNAME],
            row[:SUBSTANCENAME],
            row[:ACTIVE_NUMERATOR_STRENGTH],
            row[:ACTIVE_INGRED_UNIT],
            row[:PHARM_CLASSES],
            row[:DEASCHEDULE]
          ])
      end
    end

    if (table_data.length > 0)
      DataImportNdcProduct.import headers, table_data, validate: false
    end
  end

  def product_headers
    [
      :PRODUCTID,
      :PRODUCTNDC,
      :PRODUCTTYPENAME,
      :PROPRIETARYNAME,
      :PROPRIETARYNAMESUFFIX,
      :NONPROPRIETARYNAME,
      :DOSAGEFORMNAME,
      :ROUTENAME,
      :STARTMARKETINGDATE,
      :ENDMARKETINGDATE,
      :MARKETINGCATEGORYNAME,
      :APPLICATIONNUMBER,
      :LABELERNAME,
      :SUBSTANCENAME,
      :ACTIVE_NUMERATOR_STRENGTH,
      :ACTIVE_INGRED_UNIT,
      :PHARM_CLASSES,
      :DEASCHEDULE
    ]
  end

  def package_headers
    [
      :PRODUCTID,
      :PRODUCTNDC,
      :NDCPACKAGECODE,
      :PACKAGEDESCRIPTION
    ]
  end

  ##############################################
  #utils below, todo: to move to a common file
  ##############################################
  def load_and_import(import_key, data_file, headers)

    #skip the first line of headers for now
    #todo check header line changed during the nightly import
    File.open(data_file, "r") do |file|
      file.readline
    end

    dir = File.dirname(data_file)
    Dir.chdir(dir) do
      puts("Splitting data file into #{@chunk_size} line chunks")
      split = `tail -n +2 #{data_file} | split -l #{@chunk_size} -a 10 - #{import_key}_chunk_`
      Dir.glob(import_key + "_chunk_*") do |file|
        new_file = File.join(dir, file)
        if block_given?
           yield(new_file, headers)
        end
      end
    end
  end

  #util
  def cleanup_temp_files
    `/bin/rm -f #{@data_folder_path}/tmp/*`
  end

  #utility: unzip file.zip -d destination_folder
  #unzip and move the content file to /tmp folder
  def unzip_it(zip_filename, unzipped_filename, folder_path)
    target_file = folder_path + '/tmp/' + unzipped_filename
    Zip::File.open(folder_path + '/' + zip_filename) do |zfile|
      zfile.extract(unzipped_filename, target_file) unless File.exist?(target_file)
    end
  end
end

