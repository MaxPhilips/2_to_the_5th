# cerner_2^5_2020

# $ ruby iasip.rb 'the gang enters a programming competition'
# opens https://iasip.link/?dGhlIGdhbmcgZW50ZXJzIGEgcHJvZ3JhbW1pbmcgY29tcGV0aXRpb24= in your browser
# system open works on macos

require 'base64'

system('open', "https://iasip.link/?#{Base64.strict_encode64(ARGV[0])}")
