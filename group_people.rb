require 'csv'

file_path = ARGV[0]
matching_type = ARGV[1]

timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
base_name = File.basename(file_path, File.extname(file_path))
output_file = "./outputs/grouped_people_by_#{matching_type}_#{base_name}_#{timestamp}.csv"

# Ensure the output directory exists
Dir.mkdir('./outputs') unless Dir.exist?('./outputs')

puts "Processing file: #{file_path}"
puts "Matching type: #{matching_type}"
rows = CSV.read(file_path, headers: true)
headers = rows.headers

puts "Headers: #{headers.inspect}"
puts "Rows: #{rows.inspect}"
puts "Number of rows: #{rows.size}"

CSV.open(output_file, 'w') do |csv|
  csv << ['GroupId'] + headers
  rows.each_with_index do |row, index|
    csv << [index] + row.fields
  end
end
puts "Output written to #{output_file}"
