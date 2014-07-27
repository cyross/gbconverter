# -*- encoding: utf-8 -*-

require './gbc_logger'

class Replaces
  def initialize
    @logger = GBCLogger.new
    @dict = {}
  end

  def [](key)
    @dict[key]
  end

  def []=(key, value)
    @dict[key] = value
  end

  def include?(key)
    @dict.include?(key)
  end
end
