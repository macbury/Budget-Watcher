class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :transactions,         :dependent => :destroy
  has_many :accounts,             :dependent => :destroy
  has_many :friendships
  has_many :friends,              :through => :friendships
  has_many :inverse_friendships,  :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends,      :through => :inverse_friendships, :source => :user
  
  after_create :setup_new_user

  def setup_new_user
    self.accounts.create name: "Portfel"
    self.accounts.create name: "Konto"
  end
end
