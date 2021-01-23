# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :links do
      primary_key :id
      
      column :slug, String, null: false
      column :target, String, null: false
    end
  end
end
