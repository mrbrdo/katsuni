require 'ip'
class IpChecker
  def initialize
    @ip_ranges_list = File.read(File.expand_path("../../vendor/alloclist.txt", __FILE__))
    @ip_ranges_list =~ /(si\.abak.*si\.zz)/m
    @ip_ranges_list = $1
    @ip_ranges_list = @ip_ranges_list.each_line.map do |line|
      if line =~ /(([\d]{1,3}\.){3}[\d]{1,3}\/[\d]{1,3})[^\d]/
        r = IP.new($1).to_range
        [r.first.to_i, r.last.to_i]
      else
        nil
      end
    end
    @ip_ranges_list.compact! # remove nils

    @ip_whitelist = File.read(File.expand_path("../../vendor/ip_whitelist.txt", __FILE__))
    @ip_whitelist = @ip_whitelist.each_line.map do |line|
      if line.empty? || line[0] == "#"
        nil
      elsif line =~ /\A([\d]{1,3}\.){3}[\d]{1,3}\Z/
        r = IP.new(line.strip).to_range
        [r.first.to_i, r.last.to_i]
      elsif line =~ /\A([\d]{1,3}\.){2}[\d]{1,3}\Z/
        r = IP.new("#{line.strip}.0/24").to_range
        [r.first.to_i, r.last.to_i]
      end
    end
    @ip_whitelist.compact!

    @ip_ranges_list += @ip_whitelist
    local = IP.new("127.0.0.1").to_i
    @ip_ranges_list.push([local, local])
  end

  def valid_ip?(ip)
    ip = IP.new(ip).to_i
    @ip_ranges_list.each do |ip_range|
      if ip >= ip_range[0] && ip <= ip_range[1]
        return true
      end
    end
    false
  end
end
