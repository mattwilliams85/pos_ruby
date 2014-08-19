class Clerk < ActiveRecord::Base
  validates :name, :presence => true
  validates :password, :presence => true
end
