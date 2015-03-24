class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :google_id
      t.string :access_token
      t.datetime :expiration_time
      t.string :image_url
      t.string :username

      t.timestamps
    end
  end
end
