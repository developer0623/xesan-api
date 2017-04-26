class AddProviderRefInProviderUsers < ActiveRecord::Migration
  def change
    add_reference :provider_users, :provider, index: true #allow multiple accts per provider
  end
end
