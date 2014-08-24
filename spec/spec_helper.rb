require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'pry'

require 'clerk'
require 'item'
require 'purchase'
require 'transaction'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Clerk.all.each { |clerk| clerk.destroy }
    Item.all.each { |item| item.destroy }
    Purchase.all.each { |purchase| purchase.destroy }
    Transaction.all.each { |transaction| transaction.destroy }
  end
end