require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/rails'
require 'active_support/testing/setup_and_teardown'
require 'rails/test_help'

require 'turn'

Turn.config do |c|
  c.format = :outline
  c.natural = true
end

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end


class MiniTest::Unit::TestCase
  include Shoulda::Matchers::ActiveModel
  extend Shoulda::Matchers::ActiveModel

  DatabaseCleaner.strategy = :transaction

  # Configure Database Cleaner
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActiveSupport::Testing::Assertions

  alias :method_name :__name__ if defined? :__name__
  
  def build_message(*args)
    args[1].gsub(/\?/, '%s') % args[2..-1]
  end

  class << self
    def must &block
      matcher = yield

      it "must #{matcher.description}" do
        result = matcher.matches? subject
        assert result, matcher.failure_message
      end
    end

    def wont &block
      matcher = yield

      it "wont #{matcher.description}" do
        result = matcher.does_not_match? subject
        assert result, matcher.negative_failure_message
      end
    end
  end
end

class ControllerSpec < MiniTest::Spec
  include ActionController::TestCase::Behavior
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers
  
  # Rails 3.2 determines the controller class by matching class names that end in Test
  # This overides the #determine_default_controller_class method to allow you use Controller
  # class names in your describe argument
  # cf: https://github.com/rawongithub/minitest-rails/blob/gemspec/lib/minitest/rails/controller.rb
  def self.determine_default_controller_class(name)
    if name.match(/.*(?:^|::)(\w+Controller)/)
      $1.safe_constantize
    else
      super(name)
    end
  end

  class << self
    alias :context :describe
  end

  before do
    @controller = self.class.name.match(/((.*)Controller)/)[1].constantize.new
    @routes = Rails.application.routes
  end

  subject do
    @controller
  end

  register_spec_type(/Controller$/, self)
end

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  before do
    @routes = Rails.application.routes
  end

  register_spec_type(/Integration$/, self)
end

class HelperTest < MiniTest::Spec
  include ActionView::TestCase::Behavior
  register_spec_type(/Helper$/, self)
end
