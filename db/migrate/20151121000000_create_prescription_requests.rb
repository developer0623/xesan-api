class CreatePrescriptionRequests < ActiveRecord::Migration
  def change
    create_table :prescription_requests do |t|

      t.belongs_to :medication, index: true  #previous medication
      t.belongs_to :user, index: true #patient
      t.belongs_to :provider, index: true #physician/prescriber
      t.string :status        # 'new', 'processing', 'denied', 'scheduled'
      t.string :note
      t.date :end_date        # when drug runs out
      t.timestamp :created_at #request date
      t.timestamp :updated_at
    end
  end
end
