class CreateOauthProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_providers do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :url
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :oauth_providers, [:uid, :provider], unique: true
  end
end
