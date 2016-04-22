#!/usr/bin/env ruby
require 'csv'
class QueueMath
  def initialize(filename = "./arrival_service_times.csv")
    # Initialize arrays
    @jobs1 = []
    @jobs2 = []
    # Read csv for arrival/service times
    CSV.foreach(filename, converters: :numeric, headers: true) do |csv|
      @jobs1 << { a: csv['a'], s: csv['s1'] }
      @jobs2 << { a: csv['a'], s: csv['s2'] }
    end

    sort_jobs! @jobs1
    sort_jobs! @jobs2

    a = get_a(@jobs1)
    s1 = get_s(@jobs1)
    s2 = get_s(@jobs2)
    r = calc_r(a)
    csv = CSV.open("interarrival.csv", "w")
    csv << ["r"]
    r.each do |r|
      csv << [r]
    end

    p "mean interarrival: #{mean(r[1..r.size])}"
    p "mean service1: #{mean(s1)}"
    p "mean service2: #{mean(s2)}"

    p "q_bar_1: #{calc_q_bar(@jobs1)}"
    p "q_bar_2: #{calc_q_bar(@jobs2)}"
    d1 = calc_d(s1, r)
    d2 = calc_d(s2, r)
    p "d_bar_1: #{mean(d1)}"
    p "d_bar_2: #{mean(d2)}"
    cn1 = calc_cn(a,d1,s1)
    cn2 = calc_cn(a,d2,s2)
    u1 = sum(s1) / cn1.to_f
    u2 = sum(s2) / cn2.to_f
    p "utilization 1: #{u1}"
    p "utilization 2: #{u2}"
    w1 = calc_w(d1,s1)
    w2 = calc_w(d2,s2)
    w1_std = calc_stdev(w1)
    w2_std = calc_stdev(w2)
    p w1
    p "time in system 1: #{mean(w1)} +/- #{1.96 * w1_std}"
    p "time in system 2: #{mean(w2)} +/- #{1.96 * w2_std}"
    p "c_n1: #{cn1}"
    p "c_n2: #{cn2}"
  end

  def sort_jobs!(jobs)
    jobs.sort! { |job1, job2| job1[:a] <=> job2[:a] }
  end

  def calc_q_bar(jobs)
    n = jobs.size
    s = get_s(jobs)
    a = get_a(jobs)
    r = calc_r(a)
    d = calc_d(s, r)
    c_n = calc_cn(a, d, s)
    d_bar = mean(d)
    d_bar / c_n
  end

  def calc_cn(a, d, s)
    n = a.size
    a[n-1] + d[n-1] + s[n-1]
  end

  def sum(array)
    sum = 0
    array.each do |e|
      sum += e
    end
    sum
  end

  def mean(array)
    n = array.size
    sum(array) / n.to_f
  end

  def get_s(jobs)
    s = []
    jobs.each do |job|
      s << job[:s]
    end
    s
  end

  def get_a(jobs)
    a = []
    jobs.each do |job|
      a << job[:a]
    end
    a
  end

	# Calculate interarrival times
	def calc_r(a)
    r = []
    a.each_with_index do |e,i|
      if i > 0
        r << (a[i] - a[i-1])
      else
        r << nil
      end
    end
    r
	end

  def calc_w(d, s)
    w = []
    d.each_with_index do |e, i|
      w << (d[i] + s[i])
    end
    w
  end

  def calc_stdev(array)
    n = array.size
    sum = 0
    array.each do |e|
      sum += (e - mean(array))**2
    end
    Math.sqrt(sum.to_f / (n - 1))
  end
	# Calculate queue wait time
	def calc_d(s, r)
    n = s.size
    d = []
    n.times do |i|
      if i == 0
        d << 0
      else
        d_i = d[i-1] + s[i-1] - r[i]
        d_i = 0 if d_i <= 0
        d << d_i
      end
    end
    d
	end

  if __FILE__ == $0
    qm = QueueMath.new
  end
end
