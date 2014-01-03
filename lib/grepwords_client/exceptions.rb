module GrepwordsClient

  ##
  #
  # Generic GrepwordsClientError, inherits from StandardError

  class GrepwordsClientError < ::StandardError; end

  ##
  #
  # Raised when an error with the Keyword Tool endpoint occurs.

  class KeywordToolError < GrepwordsClientError

    ##
    #
    # Initialize new KeywordToolError
    # @private

    def initialize(method, message) # :nodoc:
      super "GrepwordsClient::KeywordTool.#{method} - #{message}"
    end

  end

end
