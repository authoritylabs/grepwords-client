# Grepwords API Gem

Wrapper gem for Grepwords API requests.

http://www.grepwords.com/api.php

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
    data     = GrepwordsClient::Endpoints.lookup(keywords)

    # Returns an array of hashes with CPC, CPM, and monthly data for given

## Todo

1. Create response class to avoid keeping track of what keywords were sent to Grepwords vs what actually came back with data.
2. Add additional endpoints (credit balance and related queries)
