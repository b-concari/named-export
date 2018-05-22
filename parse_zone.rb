#!/usr/bin/env ruby

# This script extracts CNAME, A, and PTR records from a textual zonefile

require 'rubygems'
require 'zonefile'

zf = Zonefile.from_file(ARGV[0])

zf.cname.each do |record|
    puts "CNAME\t#{record[:host]}\t#{record[:name]}"
end

zf.a.each do |record|
    puts "A\t#{record[:host]}\t#{record[:name]}"
end

zf.ptr.each do |record|
    puts "PTR\t#{record[:host]}\t#{record[:name]}"
end

