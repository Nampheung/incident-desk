class LimitUsersToOneRole < ActiveRecord::Migration[8.1]
  def change
    remove_index :users_roles, :user_id
    add_index :users_roles, :user_id, unique: true
  end
end
