#!/usr/bin/env ruby
#
# Input: a file of two columns, numbers: seconds and metric
# Output: a file of one number, collapsed hourly (3600 seconds). E.g.
#
#     0 6
#  3599 4
#  3600 7
# 10800 8
#
# Would become
#
# 5.0
# 7.0
#
# 8.0
#
# e.g. ./hourly_collapse.rb < hourly_collapse.txt
#

limit=3600
metrics=[]
ARGF.each do |line|
  # print ARGF.filename, ":", line
  seconds, metric = line.split.map { |i| i.to_f }
  if seconds >= limit
    # print out the previous metrics
    print "#{metrics.inject{ |sum, el| sum + el }.to_f / metrics.size}\n"
    metrics=[]
    limit += 3600
    while seconds >= limit
      print "\n"
      limit += 3600
    end
    metrics=[metric]
  else
    metrics << metric
  end
end
print "#{metrics.inject{ |sum, el| sum + el }.to_f / metrics.size}\n"
