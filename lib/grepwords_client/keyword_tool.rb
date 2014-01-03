module GrepwordsClient

  ##
  #
  # API calls for the Grepwords keyword lookup endpoint

  class KeywordTool

    ##
    #
    # @return [GrepwordsClient::Config]

    def self.config
      GrepwordsClient.config
    end

    ##
    #
    # Setup keywords for API calls.
    #
    # @param terms  [Array[String], String] - Defaults to an empty array. Can be an array of keywords or a string of keywords seperated by a pipe symbol "|"
    # @return       [Array] of keyword terms

    def self.setup_keywords(terms = [])
      keywords = terms.is_a?(Array) ? terms.join('|') : terms.to_s
      keywords = keywords.gsub(/\s/,'+')
      keywords[0..3949]
    end

    ##
    #
    # Keyword Lookup API call. Takes a list of keywords, seperated by a pipe symbol, and returns
    # a json payload of the keywords and their CPC, CPM, and monthly data.
    #
    # @return [Array] 
    # @raise  [KeywordToolError] If error is returned in the response body from Grepwords
    # @raise  [KeywordToolError] If bad JSON response from Grepwords
    # @example Example Response
    #     [ ]

    def self.lookup(terms)
      keywords      = setup_keywords(terms)
      path          = '/lookup'
      url_keywords  = keywords
      query         = "?apikey=#{config.apikey}&q=#{url_keywords}"
      uri           = URI.encode(config.host + path + query)
      resp          = RestClient.get( uri, {} )
      data          = JSON.parse resp.body

      return data
    rescue JSON::ParserError
      raise KeywordToolError.new('lookup', 'Bad response from Grepwords when trying to lookup keyword data.')
    end

  end

end
