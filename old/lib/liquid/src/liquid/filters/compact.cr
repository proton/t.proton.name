require "json"
require "./base"

module Liquid::Filters
  class Compact
    extend Filter

    def self.filter(data : Any, args : Array(Any)? = nil) : Any
      if (d = data.as_a?)
        result = d.reject &.raw.nil?
        JSON.parse(result.to_json)
      else
        data
      end
    end
  end

  FilterRegister.register "compact", Compact
end
