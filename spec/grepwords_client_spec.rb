require 'spec_helper'

describe GrepwordsClient do

  describe 'configure' do

    it 'can set configuration using a block' do
      GrepwordsClient.configure do |config|
        config.apikey = 'api-key'
      end
      GrepwordsClient.config.apikey.should eql 'api-key'
    end

  end

  describe 'config' do

    it 'can be accessed' do
      GrepwordsClient.config.should be_an_instance_of(GrepwordsClient::Config)
    end

    it 'can set new options' do
      GrepwordsClient.config.apikey = 'new-apikey'
      GrepwordsClient.config.apikey.should eql 'new-apikey'
    end

  end

end
