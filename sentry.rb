require 'sinatra'
require 'open-uri'
require 'uri'
require 'json'
require 'erb'
require "net/http"
require "uri"

get '/sentry' do
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
  @sumjson ={}
  @newdata = 0
  @sentryresponse[0]["stats"]["24h"].last do |time, count|
    puts "#{time.to_i}, #{count}"
    @newdata += count
  end
  @sumjson.merge!(count: "#{@newdata}")
  puts "#{@newdata}"
  @sumjson.to_json

end
