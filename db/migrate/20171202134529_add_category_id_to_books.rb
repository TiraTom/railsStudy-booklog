class AddCategoryIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :category_id, :integer, foreign_key: true
  end
end
