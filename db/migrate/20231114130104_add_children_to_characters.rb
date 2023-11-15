class AddChildrenToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :children, :string
  end
end
