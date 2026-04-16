class CreateClientShareTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :client_share_tokens do |t|
      t.references :client, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at

      t.timestamps
    end

    add_index :client_share_tokens, :token, unique: true
  end
end
