class CreateRecommendedLinks < ActiveRecord::Migration
  def change
    create_table :recommended_links do |t|

      t.string :title
      t.string :url
      t.timestamps null: false
    end
  end
end
