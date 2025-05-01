require "sinatra"
require "sinatra/reloader"
require "http"
require "dotenv/load"

get("/") do
  @cur_abb = get_currencies()

  erb(:homepage)

end

get("/:exchange_from") do
  @cur_abb = get_currencies()
  @original_currency = params.fetch("exchange_from")

  erb(:convert_to)
end

get("/:exchange_from/:exchange_to") do
  @original_currency = params.fetch("exchange_from")
  @destination_currency = params.fetch("exchange_to")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_KEY")}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  raw_response = HTTP.get(api_url)
  raw_string = raw_response.to_s
  parsed_data = JSON.parse(raw_string)

  @exchange_rate = parsed_data.fetch("result")

  erb(:result)
end

def get_currencies()
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_KEY")}"

  raw_response = HTTP.get(api_url)

  raw_string = raw_response.to_s

  parsed_data = JSON.parse(raw_string)

  currencies = parsed_data.fetch("currencies")

  return currencies.keys()
end
