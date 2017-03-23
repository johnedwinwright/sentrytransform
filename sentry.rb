require 'sinatra'
require 'open-uri'
require 'uri'
require 'json'
require 'erb'
require "net/http"
require "uri"

get '/sentry' do
  project = params[:project]
  content_type :json

  @sentry_key = ENV['sentry_key']

  uri = URI.parse("https://app.getsentry.com/api/0/projects/cnncom/#{project.downcase}/issues/?statsPeriod=24h")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  request["Authorization"] = "Bearer #{@sentry_key}"
  response = http.request(request)

  if response.message == "OK"

    @sentryresponse = JSON.parse(response.body)
    @sumjson ={}
    @newdata = 0

    puts "#{@sentryresponse}"

    loopcount = 0
    @sentryresponse[0]["stats"]["24h"].each do |time, count|
      puts "#{time.to_i}, #{count}"
      loopcount += 1
      if loopcount == 24
        @newdata += count
      end
    end
    @sumjson.merge!(count: "#{@newdata}")
    puts "#{@newdata}"
    @sumjson.to_json

  else
    response.message.to_json
  end

end
