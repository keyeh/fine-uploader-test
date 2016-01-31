class AddFileInfoToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :key, :string
    add_column :uploads, :uuid, :string
    add_column :uploads, :name, :string
    add_column :uploads, :bucket, :string
  end
end
