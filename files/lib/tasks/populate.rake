namespace :db do

  desc "Populate Database"
  task :populate => :environment do
    
    puts "Resetting the DB"
    # Rake::Task['db:reset'].invoke
    
    puts "Creating 49 Users"
    49.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      user = User.create!(
        :email => "#{first_name}.#{last_name}@example.org", 
        :password => 'letmein123', 
        :password_confirmation => 'letmein123'
      )
    end
    
  end

end