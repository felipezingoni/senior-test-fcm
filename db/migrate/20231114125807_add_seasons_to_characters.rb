class AddSeasonsToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :seasons, :string
  end
end
