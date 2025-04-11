require 'csv'

if ARGV.size < 2
  puts 'Usage: ruby group_people.rb <file_path> <matching_type>'
  exit 1
end

file_path = ARGV[0]
matching_type = ARGV[1]

unless File.exist?(file_path)
  puts "File not found: #{file_path}"
  exit 1
end

unless %w[email phone email_or_phone].include?(matching_type)
  puts "Invalid matching type: #{matching_type}. Use 'email', 'phone', or 'email_or_phone'."
  exit 1
end

timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
base_name = File.basename(file_path, File.extname(file_path))
output_file = "./outputs/grouped_people_by_#{matching_type}_#{base_name}_#{timestamp}.csv"

# Ensure the output directory exists
Dir.mkdir('./outputs') unless Dir.exist?('./outputs')

puts "Processing file: #{file_path}"
puts "Matching type: #{matching_type}"
rows = CSV.read(file_path, headers: true)
headers = rows.headers

CSV.open(output_file, 'w') do |csv|
  csv << ['GroupId'] + headers
  rows.each_with_index do |row, index|
    csv << [index] + row.fields
  end
end
puts "Output written to #{output_file}"
