ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def start_of_current_month
    Date.today.strftime("%Y-%m-01")
  end

  def end_of_current_month
    day = Date.today.day
    month = Date.today.month
    Date.new(day, month, -1)
  end
end
