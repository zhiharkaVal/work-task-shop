ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/unit'
require 'rails/test_help'
require 'mocha/minitest'

class ActiveSupport::TestCase
  fixtures :all
end
