require 'spec_helper'

describe GrepwordsClient::Endpoints do

  let(:config)        { GrepwordsClient.config }
  let(:keywords_good) { ['apple', 'ipad air', 'http://google.com/?q=sports+cards&lang=en-us'] }
  let(:keywords_bad)  { %w(| \n) }

  describe 'setup keywords' do

    it 'encodes keyword names correctly' do
      keywords = GrepwordsClient::Endpoints.escape_keywords(keywords_good)
      expect(keywords).to be_an_instance_of String
      expect(keywords).to eq 'apple%7Cipad+air%7Chttp%3A%2F%2Fgoogle.com%2F%3Fq%3Dsports%2Bcards%26lang%3Den-us'
    end

    it 'correctly encodes url' do
      keywords = GrepwordsClient::Endpoints.escape_keywords(keywords_good)
      url = GrepwordsClient::Endpoints.encode_url('lookup', keywords)
      expect(url).to eq 'http://api.grepwords.com/lookup?apikey=&q=apple%7Cipad+air%7Chttp%3A%2F%2Fgoogle.com%2F%3Fq%3Dsports%2Bcards%26lang%3Den-us'
    end

    it 'correctly encodes url with country code option' do
      keywords = GrepwordsClient::Endpoints.escape_keywords(keywords_good)
      url = GrepwordsClient::Endpoints.encode_url('lookup', keywords, 'canada')
      expect(url).to eq 'http://api.grepwords.com/lookup?apikey=&q=apple%7Cipad+air%7Chttp%3A%2F%2Fgoogle.com%2F%3Fq%3Dsports%2Bcards%26lang%3Den-us&loc=canada'
    end

  end

  describe 'lookup' do

    before { set_config }

    it 'sets max keyword length to 3950' do
      terms = []
      1.upto(4000) { |i| terms << "keyword #{i}" }
      keywords = GrepwordsClient::Endpoints.lookup(terms)
      expect(keywords).to eq nil
    end

    context 'valid keywords', vcr: { cassette_name: 'keyword_tool/lookup/successfully/valid', record: :none } do

      subject { GrepwordsClient::Endpoints.lookup(keywords_good) }

      it { expect be_an_instance_of Hash }
      it { expect have_key 'apple' }
      it { expect have_key 'ipad air' }

      it 'returns correct properties' do
        %w(cpc cmp gms lms m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12).each do |property|
          expect(subject['apple']).to have_key property
          expect(subject['ipad air']).to have_key property
        end
      end

    end

    context 'invalid keywords', vcr: { cassette_name: 'keyword_tool/lookup/unsuccessfully/with_error', record: :none } do

      subject(:response) { GrepwordsClient::Endpoints.lookup(keywords_bad) }

      it { expect be_an_instance_of Hash }
      it { expect have_key '|' }
      it { expect have_key '\n' }

      it 'returns nil values' do
        expect(response['|']).to eq nil
        expect(response['\n']).to eq nil
      end

    end

  end

end
