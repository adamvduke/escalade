class AddProjectModel < ActiveRecord::Migration
  def change
    create_table(:projects) do |t|
      t.string     :vcs_url
      t.string     :build_type
      t.references :user
      t.timestamps null: false
    end
  end
end
