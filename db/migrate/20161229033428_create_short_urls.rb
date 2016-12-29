class CreateShortUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :short_urls do |t|
      t.string :short_path, unique: true, null: false
      t.string :original_url, null: false

      t.timestamps
    end
  end
end
