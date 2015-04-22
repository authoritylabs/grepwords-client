module GrepwordsClientHelpers

  def set_config(apikey='123456789')
    GrepwordsClient.configure do |config|
      config.apikey = apikey
    end
  end

end
