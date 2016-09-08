require_relative '../spec_helper'

describe Dogapi::Client do
  EMBED_ID = 42_424_242
  GRAPH_JSON = '{
  "requests": [{
    "q": "avg:system.load.1{*}"
  }],
  "viz": "timeseries",
  "events": []
}'.freeze

  describe '#get_all_embeds' do
    it_behaves_like 'an api method',
                    :get_all_embeds, [],
                    :get, '/graph/embed'
  end

  describe '#get_embed' do
    it_behaves_like 'an api method with optional params',
                    :get_embed, [EMBED_ID],
                    :get, "/graph/embed/#{EMBED_ID}",
                    embed_size: 'medium', timeframe: '1_hour', legend: 'no', title: 'fsafasfdas'
  end

  describe '#create_embed' do
    it_behaves_like 'an api method with options',
                    :create_embed, [GRAPH_JSON],
                    :post, '/graph/embed', graph_json: GRAPH_JSON
  end

  describe '#enable_embed' do
    it_behaves_like 'an api method',
                    :enable_embed, [EMBED_ID],
                    :get, "/graph/embed/#{EMBED_ID}/enable"
  end

  describe '#revoke_embed' do
    it_behaves_like 'an api method',
                    :revoke_embed, [EMBED_ID],
                    :get, "/graph/embed/#{EMBED_ID}/revoke"
  end
end
