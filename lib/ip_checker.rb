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
  end

  def valid_ip?(ip)
    ip = IP.new(ip).to_i
    return true if ip == IP.new("127.0.0.1").to_i
    @ip_ranges_list.each do |ip_range|
      if ip >= ip_range[0] && ip <= ip_range[1]
        return true
      end
    end
    false
  end
end
