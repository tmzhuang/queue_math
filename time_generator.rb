#!/usr/bin/env ruby
require "csv"

count = 20
elapsed_time = 0

File.delete("./test.csv")
CSV.open("./test.csv","w") do |csv|
	csv << ['Arrival times', 'Service times']
end

count.times do 
	# randomo service time
	s = rand 1.0..4.0
	CSV.open("./test.csv", "a") do |csv|
		csv << [elapsed_time, s]
	end

	# write to csv
	# random interarrival time
	r = rand 1.0..4.0
	elapsed_time += r
end

data = CSV.read("./test.csv", converters: :numeric, headers: true) 
p data.headers
CSV.foreach("./test.csv", converters: :numeric, headers: true) do |csv|
	print csv['Arrival times']
	print ", "
	print csv['Service times']
	puts
end
