# -*- encoding: utf-8 -*-

require 'logger'

class GBCLogger
  @@logger = nil

  def initialize(filepath = "gbconverter.log", output_info = false)
    if @@logger.nil?
      @@logger = Logger.new(filepath)
      @@logger.level = Logger::INFO
    end
    @logger = @@logger
    @output_info = output_info
  end

  def fatal(msg)
    $stderr.puts "致命的エラー：#{msg}"
    @logger.fatal(msg)
  end

  def error(msg)
    $stderr.puts "エラー：#{msg}"
    @logger.error(msg)
  end

  def warn(msg)
    $stderr.puts "警告：#{msg}"
    @logger.warn(msg)
  end

  def info(msg)
    puts msg if @output_info
    @logger.info(msg)
  end
end
