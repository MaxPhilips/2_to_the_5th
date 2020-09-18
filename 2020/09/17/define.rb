# cerner_2^5_2020

require 'cgi'
require 'json'
require 'net/http'

abort 'the definition of nothing is nothing' unless ARGV[0]

abort 'one word at a time please' if ARGV[1]

def createURI(word)
  URI("https://owlbot.info/api/v4/dictionary/#{CGI.escape(word)}")
end

def parseDefinition(definition, index)
  message = "#{index + 1}). #{definition['type']}: #{definition['definition']}"
  example = definition['example']
  emoji = definition['emoji']

  [message, example, emoji].compact.reject { |i| i == '' }.join(' | ')
end

uri = createURI(ARGV[0])
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Token <my owlbot token>"

res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) { |http| http.request(req) }

abort 'a definition was not found' if res.kind_of? Net::HTTPNotFound

abort 'you may have a goofy character in your word' if res.body.include?('Error 404 (Not found)')

JSON.parse(res.body)['definitions'].each_with_index { |definition, index| puts parseDefinition(definition, index) }
