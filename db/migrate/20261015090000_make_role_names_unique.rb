class MakeRoleNamesUnique < ActiveRecord::Migration[8.1]
  def change
    remove_index :roles, :name
    add_index :roles, :name, unique: true
  end
end
