require 'ipaddr'

module Nifty
  module Utils
    module Networks

      def self.ip_in_networks?(ip, networks = [])
        !!network_for_ip(networks, ip)
      end

      def self.network_for_ip(networks, ip)
        networks.each do |i|
          if IPAddr.new(i).include?(ip)
            return i
          end
        end
        return nil
      rescue ArgumentError => e
        if e.message == 'invalid address'
          return nil
        else
          raise
        end
      end

    end
  end
end
