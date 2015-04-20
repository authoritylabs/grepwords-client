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
      return nil unless keywords.is_a?(Array) && keywords.size < 3950

      query_string = self.escape_keywords(keywords)
      url = self.encode_url('lookup', query_string)

      begin
        resp = RestClient.get(url, {})
      rescue => e
        puts e.message
        puts " --- FAILED URI: #{url}"
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
        grepwords_by_keyword[CGI.unescape keyword] = grepwords_data[keyword]
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

      def encode_url(endpoint, query_string)
        modified_query_string = "?apikey=#{config.apikey}&q=#{query_string}"
        URI.encode(config.host + '/' + endpoint) + modified_query_string
      end

      def escape_keywords(keywords)
        modified_keywords = keywords.join('|')
        CGI.escape(modified_keywords).to_s
      end
    end

  end
end
