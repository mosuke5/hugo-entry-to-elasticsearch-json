require "pp"
require "json"
require "tomlrb"
require "commonmarker"
require "sanitize"

contents_path = ARGV[0]
Dir.glob("#{contents_path}**/*.md") do |entry_list|
  File.open(entry_list, "r") do |entry| 
     entry_raw_data = entry.read.split("+++\n")
     entry_data = Tomlrb.parse(entry_raw_data[1])
     body_html = CommonMarker.render_html(entry_raw_data[2])
     body = Sanitize.fragment(body_html)
     entry_data["body"] =  body
     puts "{ \"index\" : {} }"
     puts entry_data.to_json
  end
end
