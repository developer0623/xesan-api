class CreateProviderUsers < ActiveRecord::Migration
  def change
    create_table :providers_users do |t|
      t.belongs_to :provider, index: true
      t.belongs_to :user, index: true
    end
  end
end
