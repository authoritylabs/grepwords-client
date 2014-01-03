require 'simplecov'
SimpleCov.start

project_root = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH << "#{project_root}/lib"

require 'rubygems'
require 'grepwords_client'
require 'vcr'

Dir[("#{project_root}/spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.extend VCR::RSpec::Macros
  config.include GrepwordsClientHelpers
end

VCR.configure do |config|
  config.hook_into                :webmock
  config.cassette_library_dir     = 'spec/support'
  config.ignore_localhost         = true
  config.default_cassette_options = { :record => :none }
end
