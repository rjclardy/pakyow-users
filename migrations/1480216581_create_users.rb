Sequel.migration do
  up do
	create_table :users do
	  primary_key :id
	  String		:email
	  String 		:crypted_password
	  String 		:timezone, default: "America/Chicago"
	  TrueClass 	:active, default: true
	  Time 			:created_at
	  Time 			:updated_at
	end
  end

  down do
	drop_table :users, cascade: true
  end
end
