class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.string :ip, null: false
      t.string :user_agent, null: false
      t.string :referrer
      t.string :uid, null: false

      t.references :short_url, foreign_key: true

      t.datetime :created_at, null: false
    end
  end
end
