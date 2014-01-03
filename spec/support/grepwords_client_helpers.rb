module GrepwordsClientHelpers

  def set_config(apikey='1234567890')
    GrepwordsClient.configure do |config|
      config.apikey = apikey
    end
  end

end
