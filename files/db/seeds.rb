# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

user = User.create(
  first_name: 'Admin',
  last_name: 'User',
  email: 'admin@example.org', 
  password: 'letmein123', 
  password_confirmation: 'letmein123'
).add_role "admin"