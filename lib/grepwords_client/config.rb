module GrepwordsClient

  ##
  #
  # Config class used internally for API calls

  class Config

    DEFAULT_HOST = 'http://api.grepwords.com'
    DEFAULT_PORT = 80

    attr_accessor :apikey
    attr_reader   :host, :port

    ##
    #
    # @private

    def initialize
      @host = DEFAULT_HOST
      @port = DEFAULT_PORT
    end
  end

end
