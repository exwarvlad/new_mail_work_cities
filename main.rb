require 'net/http'
require 'json'
require 'sinatra'

f = File.read('public/application.json')
data = JSON.parse(f)
data[:apiKey] = ENV['apiKey']
data = JSON[data]

uri = URI('http://testapi.novaposhta.ua/v2.0/json/Address/getCities')

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request body
request.body = data

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

j = JSON.parse(response.body)
array = []

j['data'].each do |city|
  city_hash = city.to_h
  array.push city_hash['DescriptionRu']
end

get '/' do
  @array = array
  erb :index, :locals => {:name => params[:name]}
end