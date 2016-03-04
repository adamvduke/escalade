class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :vcs_url
      t.string :build_type
      t.string :name
      t.string :domain_name
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end

   drop_table :projects
  end
end
