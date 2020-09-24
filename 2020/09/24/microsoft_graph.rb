# cerner_2^5_2020

require 'faraday'
require 'json'

# given a microsoft tenant, a registered application and its secret, and a video teleconference id,
# this script grabs an oauth2 token for your application
# and reads the onlineMeetings graph api for the vtc id

def app_only_access_token(tenant, client_id, client_secret)
  token_conn = Faraday.new(
    url: "https://login.microsoftonline.com/#{tenant}/oauth2/v2.0/token",
    headers: {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'SdkVersion' => 'postman-graph/v1.0'
    }
  )

  resp = token_conn.post do |req|
    req.body = "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}&scope=https%3A//graph.microsoft.com/.default"
  end

  return "Bearer #{JSON.parse(resp.body)['access_token']}"
end

def online_meeting(bearer_token, vtc)
  graph_conn = Faraday.new(
    url: "https://graph.microsoft.com/v1.0/",
    headers: {
      'Authorization' => bearer_token,
      'SdkVersion' => 'postman-graph/v1.0'
    }
  )

  resp = graph_conn.get('communications/onlineMeetings') do |req|
    req.params['$filter'] = "VideoTeleconferenceId eq '#{vtc}'"
  end

  return JSON.parse(resp.body)
end

# input expected as:
# 0 - tenant
# 1 - client id
# 2 - client secret
# 3 - vtc conference id

bearer_token = app_only_access_token(ARGV[0], ARGV[1], ARGV[2])

puts JSON.pretty_generate(online_meeting(bearer_token, ARGV[3]))
