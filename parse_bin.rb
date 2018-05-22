#!/usr/bin/env ruby

# This script verifies the structure of a zonefile (binary)

require 'rubygems'
require 'bindata'

class NameInfo < BinData::Record
    uint8 :len
    string :name, :read_length => :len
end

class Zoneheader < BinData::Record
    endian :big
    skip :length => 42
    uint16 :len
    #string :domain, :read_length => :len
    buffer :names, :length => :len do
        array :type => :NameInfo, :read_until => :eof
    end
end

io = File.open(ARGV[0])
zh = Zoneheader.read(io)
puts zh.names.map{|word| word.name}.join('.')
