require 'json'
require 'rest-client'
require 'net/http'

require File.dirname(__FILE__) + '/grepwords_client/config'
require File.dirname(__FILE__) + '/grepwords_client/exceptions'
require File.dirname(__FILE__) + '/grepwords_client/endpoints'

module GrepwordsClient

  extend self

  ##
  #
  # Takes a block where you can configure your API key
  # @example Sample Configuration
  #     GrepwordsClient.configure do |config|
  #       config.apikey = 'my-api-key'
  #     end

  def configure
    yield config
  end

  ##
  #
  # Used to access your current configuration for API calls.
  # @return [GrepwordsClient::Config] Config object with your current settings

  def config
    @config ||= Config.new
  end

end
