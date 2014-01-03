require 'spec_helper'

describe GrepwordsClient::Config do

  it 'sets defaults when initialized' do
    config = GrepwordsClient.config
    config.host.should eql GrepwordsClient::Config::DEFAULT_HOST
    config.port.should eql GrepwordsClient::Config::DEFAULT_PORT
  end

end
