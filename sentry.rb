require 'sinatra'
require 'open-uri'
require 'uri'
require 'json'
require 'erb'
require "net/http"
require "uri"

get '/' do
  status = "OK"
  status.to_json
end

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

    @sumjson =[]
    @presumjson ={}
    @newdata = 0
    @totalerrorsum = 0
    @totalerrorsumnode = {}
    puts "#{@sentryresponse}"

    @sentryresponse.each do |toplevel|
      if toplevel["stats"].has_key?("24h")
        loopcount = 0
        toplevel["stats"]["24h"].each do |time, count|
          puts "#{time.to_i}, #{count}"
          loopcount += 1
          if loopcount == 24
            @newdata += count
            @totalerrorsum += count
          end
        end
        #@presumjson.merge!(title: "#{toplevel["title"]}")
        @presumjson.merge!("#{toplevel["title"]}": "#{@newdata}")
        @sumjson << @presumjson
        @presumjson = {}
        @newdata = 0
      end
    end

    @totalerrorsumnode.merge!(Total_errors: "#{@totalerrorsum}")
    @sumjson << @totalerrorsumnode
    @sumjson.to_json

  else
    response.message.to_json
  end

end
