module GrepwordsClient

  ##
  #
  # API calls for the Grepwords keyword lookup endpoint

  class Endpoints

    ##
    #
    # Keyword Lookup API call. Takes a list of keywords, separated by a pipe symbol, and returns
    # a json payload of the keywords and their CPC, CPM, and monthly data.
    #
    # @return [Array]
    # @raise  [KeywordToolError] If error is returned in the response body from Grepwords
    # @raise  [KeywordToolError] If bad JSON response from Grepwords
    # @example Example Response
    #     [ ]

    def self.lookup(keywords)
      keywords_string = self.encode_keywords(keywords)
      path  = '/lookup'
      query = "?apikey=#{config.apikey}&q=#{keywords_string}"
      uri   = URI.encode(config.host + path + query)

      begin
        resp = RestClient.get(uri, {})
      rescue => e
        puts e
        puts " --- FAILED URI: #{uri}"
        return nil
      end

      begin
        data = JSON.parse(resp.body)
      rescue JSON::ParserError
        data = nil
      end

      grepwords_data = {}
      grepwords_by_keyword = {}

      if data.is_a?(Array)
        data.each do |response|
          keyword = response['keyword']
          response.delete('keyword')
          grepwords_data[keyword] = response
        end
      end

      keywords.each do |keyword|
        grepwords_by_keyword[keyword] = grepwords_data[keyword]
      end

      grepwords_by_keyword
    end

    private

    class << self
      ##
      #
      # @return [GrepwordsClient::Config]

      def config
        GrepwordsClient.config
      end

      ##
      #
      # Setup keywords for API calls.
      #
      # @param keywords  [Array[String], String] - Defaults to an empty array. Can be an array of keywords or a string of keywords seperated by a pipe symbol "|"
      # @return       [Array] of keyword keywords

      def encode_keywords(keywords = [])
        keywords = keywords.is_a?(Array) ? keywords.join('|') : keywords.to_s
        keywords = CGI.escape keywords
        keywords[0..3949]
      end
    end

  end
end
