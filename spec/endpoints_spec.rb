require 'spec_helper'

describe GrepwordsClient::KeywordTool do

  let(:config)        { GrepwordsClient.config }
  let(:keywords)      { ['apple', 'ipad'] }
  let(:bad_keywords)  { ['|', '\n'] }

  describe 'setup keywords' do

    it 'takes an array of keywords and makes newline separated string' do
      keywords = GrepwordsClient::KeywordTool.encode_keywords(['one','two','three'])
      keywords.should be_an_instance_of(String)
      keywords.should eql "one|two|three"
    end

    it 'takes a string of keywords and sets ivar' do
      terms = "my fancy keyword\nwith another keyword"
      keywords = GrepwordsClient::KeywordTool.encode_keywords(terms)
      keywords.should be_an_instance_of(String)
      keywords.should eql keywords
    end

    it 'converts keyword spaces to a plus' do
      keywords = GrepwordsClient::KeywordTool.encode_keywords(['baseball cards', 'football cards', 'sports+cards'])
      keywords.should be_an_instance_of(String)
      keywords.should eql "baseball+cards|football+cards|sports+cards"
    end

    it 'sets max keyword length to 3950' do
      terms = []
      1.upto(4000) { |i| terms << "keyword #{i}" }
      keywords = GrepwordsClient::KeywordTool.encode_keywords(terms)
      keywords.length.should eql 3950
    end

  end

  describe 'lookup' do

    before { set_config }

    context 'successfully' do

      use_vcr_cassette 'keyword_tool/lookup/successfully/valid', :record => :none

      it 'returns keyword data' do
        results = GrepwordsClient::KeywordTool.lookup(keywords)
        results.should be_an_instance_of(Array)
        results.should eql [{"cpc"=>2.4, "cmp"=>0.05, "gms"=>4090000, "lms"=>4090000, "m1"=>5000000, "m2"=>4090000, "m3"=>3350000, "m4"=>3350000, "m5"=>2740000, "m6"=>2740000, "m7"=>4090000, "m8"=>3350000, "m9"=>3350000, "m10"=>7480000, "m11"=>4090000, "m12"=>0, "keyword"=>"apple"}, {"cpc"=>1.57, "cmp"=>0.94, "gms"=>1000000, "lms"=>1000000, "m1"=>1830000, "m2"=>1000000, "m3"=>1000000, "m4"=>1000000, "m5"=>1000000, "m6"=>823000, "m7"=>673000, "m8"=>673000, "m9"=>823000, "m10"=>823000, "m11"=>1000000, "m12"=>0, "keyword"=>"ipad"}] 
      end

    end

    context 'unsuccessfully' do

      use_vcr_cassette 'keyword_tool/lookup/unsuccessfully/with_error', :record => :none

      it 'raises keyword tool error with error message' do
        expect { GrepwordsClient::KeywordTool.lookup(bad_keywords) }.to raise_error(GrepwordsClient::KeywordToolError, /Bad response from Grepwords when trying to lookup keyword data./i)
      end

    end

  end

end
