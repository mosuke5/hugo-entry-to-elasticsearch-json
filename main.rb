require "pp"
require "json"
require "tomlrb"
require "commonmarker"
require "sanitize"

# path of hugo markdown contents
contents_path = ARGV[0]

Dir.glob("#{contents_path}**/*.md") do |entry_list|
  uri = entry_list.slice(contents_path.length-1..-4)
  File.open(entry_list, "r") do |entry| 
    # Split data to meta info and body
    entry_raw_data = entry.read.split("+++\n")

    # Convert meta info(toml) to ruby obj
    entry_data = Tomlrb.parse(entry_raw_data[1])

    # temporary hash for output
    tmp = {}
    
    # convert hash key name to letter(ex. Tags -> tags)
    entry_data.each do |k, v|
      tmp[k.downcase] = v
    end
    
    # sanitize html tags
    body_html = CommonMarker.render_html(entry_raw_data[2])
    body = Sanitize.fragment(body_html)
    tmp["body"] =  body
    tmp["uri"] = "/entry#{uri}"

    # output 
    puts "{ \"index\" : { \"_index\" : \"blog\", \"_type\" : \"entry\", \"_id\" : \"#{uri}\" } }"
    puts tmp.to_json
  end
end
