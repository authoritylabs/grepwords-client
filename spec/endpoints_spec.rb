require 'spec_helper'

describe GrepwordsClient::Endpoints do

  let(:config)        { GrepwordsClient.config }
  let(:keywords)      { ['apple', 'ipad'] }
  let(:bad_keywords)  { ['|', '\n'] }

  describe 'setup keywords' do

    it 'takes an array of keywords and makes newline separated string' do
      keywords = GrepwordsClient::Endpoints.encode_keywords(['one','two','three'])
      keywords.should be_an_instance_of(String)
      keywords.should eql "one|two|three"
    end

    it 'takes a string of keywords and sets ivar' do
      terms = "my fancy keyword\nwith another keyword"
      keywords = GrepwordsClient::Endpoints.encode_keywords(terms)
      keywords.should be_an_instance_of(String)
      keywords.should eql keywords
    end

    it 'converts keyword spaces to a plus' do
      keywords = GrepwordsClient::Endpoints.encode_keywords(['baseball cards', 'football cards', 'sports+cards'])
      keywords.should be_an_instance_of(String)
      keywords.should eql "baseball+cards|football+cards|sports+cards"
    end

    it 'sets max keyword length to 3950' do
      terms = []
      1.upto(4000) { |i| terms << "keyword #{i}" }
      keywords = GrepwordsClient::Endpoints.encode_keywords(terms)
      keywords.length.should eql 3950
    end

  end

  describe 'lookup' do

    before { set_config }

    context 'successfully', vcr: { cassette_name: 'keyword_tool/lookup/successfully/valid', record: :none } do

      subject(:response) { GrepwordsClient::Endpoints.lookup(keywords) }

      it 'returns a hash of keywords' do
        expect(response).to be_an_instance_of Hash
      end

      it 'returns a key for each keyword' do
        expect(response).to have_key 'apple'
        expect(response).to have_key 'ipad'
      end

      it 'returns correct keyword data' do
        %w(cpc cmp gms lms m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12).each do |property|
          expect(response['apple']).to include property
          expect(response['ipad']).to include property
        end
      end

    end

    context 'unsuccessfully', vcr: { cassette_name: 'keyword_tool/lookup/unsuccessfully/with_error', record: :none } do

      subject(:response) { GrepwordsClient::Endpoints.lookup(bad_keywords) }

      it 'raises keyword tool error with error message' do
        expect(response).to raise_error(GrepwordsClient::KeywordToolError, /Bad response from Grepwords when trying to lookup keyword data./i)
      end

    end

  end

end
