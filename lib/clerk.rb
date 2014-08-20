class Clerk < ActiveRecord::Base
  validates :name, :presence => true
  validates :password, :presence => true, 
  			:length => {:maximum => 12}, 
  			:length => {:minimum => 4}
end
