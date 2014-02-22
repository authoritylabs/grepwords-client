require 'spec_helper'

describe GrepwordsClient::Endpoints do

  let(:config)        { GrepwordsClient.config }
  let(:keywords_good) { ['apple', 'ipad'] }
  let(:keywords_bad)  { ['|', '\n'] }

  describe 'setup keywords' do

    it 'takes an array of keywords and makes newline separated string' do
      keywords = GrepwordsClient::Endpoints.encode_keywords(keywords_good)
      keywords.should be_an_instance_of(String)
      keywords.should eql 'apple|ipad'
    end

    it 'encodes keyword names correctly' do
      keywords = GrepwordsClient::Endpoints.encode_keywords(['baseball+cards', 'football cards', 'http://google.com/?q=sports+cards&lang=eng'])
      keywords.should be_an_instance_of(String)
      keywords.should eql 'baseball%2Bcards|football+cards|http%3A%2F%2Fgoogle.com%2F%3Fq%3Dsports%2Bcards%26lang%3Deng'
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

    context 'valid keywords', vcr: { cassette_name: 'keyword_tool/lookup/successfully/valid', record: :none } do

      subject(:response) { GrepwordsClient::Endpoints.lookup(keywords_good) }

      it { should be_an_instance_of Hash }
      it { should have_key 'apple' }
      it { should have_key 'ipad' }

      it 'returns correct properties' do
        %w(cpc cmp gms lms m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12).each do |property|
          expect(response['apple']).to include property
          expect(response['ipad']).to include property
        end
      end

    end

    context 'invalid keywords', vcr: { cassette_name: 'keyword_tool/lookup/unsuccessfully/with_error', record: :none } do

      subject(:response) { GrepwordsClient::Endpoints.lookup(keywords_bad) }

      it { should be_an_instance_of Hash }
      it { should have_key '|' }
      it { should have_key '\n' }

      it 'returns nil values' do
        expect(response['|']).to be nil
        expect(response['\n']).to be nil
      end

    end

  end

end
