require 'sinatra'
require 'net/http'
require 'rubygems'
require 'nokogiri'
require 'json'

get '/' do
  File.read('index.html')
end

get '/getairports' do
  statesMap = {
    "ALABAMA" => "AL",
 "ALASKA" => "AK",
 "AMERICA SAMOA" => "AS",
"ARIZONA" => "AZ",
"ARKANSAS" => "AR",
"CALIFORNIA" => "CA",
"COLORADO" => "CO",
"CONNECTICUT" => "CT",
"DELAWARE" => "DE",
"DISTRICT OF COLUMBIA" => "DC",
"MICRONESIA1" => "FM",
"FLORIDA" => "FL",
"GEORGIA" => "GA",
"GUAM" => "GU",
"HAWAII" => "HI",
"IDAHO" => "ID",
"ILLINOIS" => "IL",
"INDIANA" => "IN",
"IOWA" => "IA",
"KANSAS" => "KS",
"KENTUCKY" => "KY",
"LOUISIANA" => "LA",
"MAINE" => "ME",
"ISLANDS1" => "MH",
"MARYLAND" => "MD",
"MASSACHUSETTS" => "MA",
"MICHIGAN" => "MI",
"MINNESOTA" => "MN",
"MISSISSIPPI" => "MSI",
"MISSOURI" => "MO",
"MISSOURI" => "MT",
"NEBRASKA" => "NE",
"NEVADA" => "NV",
"NEW HAMPSHIRE" => "NH",
"NEW JERSEY" => "NJ",
"NEW MEXICO" => "NM",
"NEW YORK" => "NY",
"NORTH CAROLINA" => "NC",
"NORTH DAKOTA" => "ND",
"OHIO" => "OH",
"OKLAHOMA" => "OK",
"OREGON" => "OR",
"PALAU" => "PW",
"PENNSYLVANIA" => "PA",
"PUERTO RICO" => "PR",
"RHODE ISLAND" => "RI",
"SOUTH CAROLINA" => "SC",
"SOUTH DAKOTA" => "SD",
"TENNESSEE" => "TN",
"TEXAS" => "TX",
"UTAH" => "UT",
"VERMONT" => "VT",
"VIRGIN ISLAND" => "VI",
"VIRGINIA" => "VA",
"WASHINGTON" => "WA",
"WEST VIRGINIA" => "WV",
"WISCONSIN" => "WI",
"WYOMING" => "WY"
}
  result = Net::HTTP.get(URI.parse('http://en.wikipedia.org/wiki/List_of_airports_in_the_United_States'))
  doc = Nokogiri::HTML(result)
  table = doc.search("table.wikitable")
  states = Hash.new
  stateinfo = Hash.new
  state = ""
  statecities = []
  cities = Hash.new
  tdcnt = 0
  table.search('tr').each do |tr|
    tdcnt = 0
    if tr.search('td>cite').count > 0
      tr.search('td>cite').each do |td|
      #statecities << cities
      if state != ""
        state_abbr = statesMap.key(state)
        states["cities"] = statecities
        states["airportNumber"] = statecities.count
        if statecities.count<=5
          states["fillKey"] = "low"
        else if statecities.count<=10
          states["fillKey"] = "medium"
        else if statecities.count>10
          states["fillKey"] = "high"
        end
        end
        end
        stateinfo[statesMap[state]] = states
        states = Hash.new
        cities = Hash.new
        statecities = Array.new
      end
      state = td.next_sibling().text
      end
    else
      if cities.count > 0
        statecities << cities
      end
      cities = Hash.new
      tr.search('td').each do |td|
        tdcnt = tdcnt + 1
        if tdcnt == 1
          cities['city'] = td.text.to_s
        else if tdcnt == 5
            cities['airport'] = td.text.to_s
          else if tdcnt == 7
              num = td.text.gsub!(',','')
              cities['enplanements'] = num.to_i
            end
          end
        end
      end
    end
  end
  stateinfo.to_json
end
