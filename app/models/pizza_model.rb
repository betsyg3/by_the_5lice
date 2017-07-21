require "awesome_print"
AwesomePrint.irb!
require "http"
require "optparse"
require "json"

CLIENT_ID = "w58OT-e3oacHaiuVyRJhZg"
CLIENT_SECRET = "jvnpZx44NBNOAmmEuJTjXboXdzDNFCVFUbjNDNxYkESocuD2MX0zq64nfqr5s2a9"

# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
TOKEN_PATH = "/oauth2/token"
GRANT_TYPE = "client_credentials"


DEFAULT_BUSINESS_ID = "yelp-new-york"
DEFAULT_TERM = "pizza"
DEFAULT_LOCATION = "Lower East Side, NY"
SEARCH_LIMIT = 12

def bearer_token
  # Put the url together
  url = "#{API_HOST}#{TOKEN_PATH}"

raise "Please set your CLIENT_ID" if CLIENT_ID.nil?
raise "Please set your CLIENT_SECRET" if CLIENT_SECRET.nil?

  # Build our params hash
  params = {
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET,
    grant_type: GRANT_TYPE
  }

  response = HTTP.post(url, params: params)
  parsed = response.parse

  "#{parsed['token_type']} #{parsed['access_token']}"
end

def search(term, location)
  url = "#{API_HOST}#{SEARCH_PATH}"
  params = {
    term: term,
    location: location,
    limit: SEARCH_LIMIT
  }

  response = HTTP.auth(bearer_token).get(url, params: params)
  response.parse
end

# def business(business_id)
#   url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"

#   response = HTTP.auth(bearer_token).get(url)
#   response.parse
# end


options = {}
OptionParser.new do |opts|
  opts.banner = "Example usage: ruby sample.rb (search|lookup) [options]"

  opts.on("-tTERM", "--term=TERM", "Search term (for search)") do |term|
    options[:term] = term
  end

  opts.on("-lLOCATION", "--location=LOCATION", "Search location (for search)") do |location|
    options[:location] = location
  end

  opts.on("-bBUSINESS_ID", "--business-id=BUSINESS_ID", "Business id (for lookup)") do |id|
    options[:business_id] = id
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!


command = ARGV


def get_info(location)
  term = "best pizza"
  location = location

  #raise "business_id is not a valid parameter for searching" if options.key?(:business_id)

  response = search(term, location)
  puts response

#   puts "Found #{response["total"]} businesses. Listing #{SEARCH_LIMIT}:"
  info = {}
  names = []
  ratings = []
  prices = []
  locations1 = []
  locations2 = []
  pictures = []
  phone_number=[]
  

  response["businesses"].each {|biz| info[:names]=names.push(biz["name"])}
  response["businesses"].each {|biz| info[:ratings]=ratings.push(biz["rating"])}
  response["businesses"].each {|biz| info[:prices]=prices.push(biz["price"])}
  response["businesses"].each {|biz| info[:locations1]=locations1.push(biz["location"]["display_address"][0])}
  response["businesses"].each {|biz| info[:locations2]=locations2.push(biz["location"]["display_address"][1])}
  response["businesses"].each {|biz| info[:pictures]=pictures.push(biz["image_url"])}
  response["businesses"].each {|biz| info[:phone_number]=phone_number.push(biz["display_phone"])}
  
#   response["businesses"].each {|biz| puts biz[:location][:address1]}
return info
end

#get_info(@neighborhood)

    







