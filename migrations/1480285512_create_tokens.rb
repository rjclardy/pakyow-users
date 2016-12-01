Sequel.migration do
  up do
    create_table :tokens do
      primary_key :id
      foreign_key :user_id, :users
      String :type
      String :code
      TrueClass :valid, default: true
      Time :used_at
      Time :expires_at
      Time :created_at
      Time :updated_at
    end
  end

  down do
    drop_table :tokens, cascade: true
  end
end
