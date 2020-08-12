ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'

# clear tmp cache, to avoid random errors
test_cache_path = "#{Rails.root}/tmp/test_cache/"
FileUtils.rm_rf(test_cache_path) if Dir.exist?(test_cache_path)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def recipes
    @recipes ||= Recipe.all_samples
  end
end

