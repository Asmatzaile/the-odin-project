require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phonenumber(phonenumber)
  phonenumber = phonenumber.to_s.gsub(/[^0-9]/i, '')
  if phonenumber.length == 11 && phonenumber[0] == "1"
    phonenumber.slice!(0)
  end
  return phonenumber if phonenumber.length == 10
  '0000000000'
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'  

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.comoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('../output') unless Dir.exist?('../output')
  filename = "../output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def store_time(time, hours, wdays)
  p time = Time.strptime(time, "%D %R") # %D is date (%m/%d/%y) and %R is time, 24-hour (%H:%M)
  hours[time.hour] += 1
  wdays[wday_num_2_name(time.wday)] += 1
end

def wday_num_2_name(wday_num)
  wday_names = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  wday_names[wday_num]
end

puts 'Event Manager Initialized!'

contents = CSV.open(
  '../event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('../form_letter.erb')
erb_template = ERB.new template_letter

hours = Hash.new(0)
wdays = Hash.new(0)
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)
  
  phonenumber = clean_phonenumber(row[:homephone])
  time = row[:regdate]
  store_time(time, hours, wdays)
end

puts 'Output generated!'

p hours = hours.sort_by { |k, v| v}.reverse.to_h
p wdays = wdays.sort_by { |k, v| v}.reverse.to_h
