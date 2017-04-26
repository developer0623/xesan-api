class CreatePendingRecommendedLinks < ActiveRecord::Migration
  def change
    create_table :pending_recommended_links do |t|

      t.string :title
      t.string :url
      t.timestamps null: false
    end
  end
end
