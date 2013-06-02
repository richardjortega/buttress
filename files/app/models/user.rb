class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  # Some basic validation of name properties
  validates_presence_of :first_name, :last_name, :email
  validates_length_of :first_name, :maximum => 50
  validates_length_of :last_name, :maximum => 50
  
  # Simple search method
  def self.search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end
  
end