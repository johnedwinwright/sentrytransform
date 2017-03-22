require 'sinatra'
require 'open-uri'
require 'uri'
require 'json'
require 'erb'
require "net/http"
require "uri"

get '/sentry/test' do
  content_type :json
  @sentry_key = ENV['sentry_key']
  uri = URI.parse("https://app.getsentry.com/api/0/projects/cnncom/dynaimage/issues/?statsPeriod=24h")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  request["Authorization"] = "Bearer #{@sentry_key}"
  response = http.request(request)

  @sentryresponse = JSON.parse(response.body)

  @newdata = []
  @sentryresponse[0]["stats"]["24h"].each do |time, count|
    puts "#{time.to_i}, #{count}"
    @newdata << [@sentryresponse[0]["title"], time.to_i, count]
  end
  puts "#{@newdata}"
  @newdata.to_json

end
