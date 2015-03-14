#!/usr/bin/env ruby

require_relative '../lib/obsfucate.rb'
require 'json'

target_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'finances2.json')) 
json = JSON.parse(File.read(target_file))
obsfucated = Obsfucate.new(json).obsfucate_data.to_json
File.open('obsfucated.json', 'w') { |file| file.write(obsfucated) }

puts 'Obsfucated finances2.json into obsfucated.json'
