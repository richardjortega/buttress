# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Create admin user
user = User.create(
  email: 'admin@example.org', 
  password: 'letmein123', 
  password_confirmation: 'letmein123'
).add_role "admin"