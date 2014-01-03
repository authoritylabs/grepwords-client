# Grepwords API Gem

Wrapper gem for Grepwords API requests.

## Description


## Install

    gem install grepwords_client

## Configuration

  To setup the gem, you need to set your Grepwords API key before making requests.

    require 'grepwords_client'

    GrepwordsClient.configure do |config|
      config.apikey = 'my-api-key'
    end

## Keyword Lookup

  To get keyword data from Grepwords, you can pass in an array of keywords.

    keywords = %w[apple ipad iphone]
    data     = GrepwordsClient::KeywordTool.lookup(keywords)

    # Returns an array of hashes with CPC, CPM, and monthly data for given keywords

    keyword_data = Hash[data]
    keywords_with_data = keyword_data.keys

## Todo

1. Add aditional endpoints (credit balance and related queries)
