# -*- encoding: utf-8 -*-

require './gbc_logger'

class Paragraph
  def initalize(label, fixed = false)
    @logger = GBCLogger.new
    @label = label
    @fixed = fixed
    @first = nil
    @last = nil
    @number = nil
    @lines = []
    @links = {}
    @linked = {}
  end

  def insert(line)
    @lines << line
  end

  def <<(line)
    insert(line)
  end

  def label
    @label
  end

  def first?
    !@first..nil? and @first
  end

  def last?
    !@last.nil? and @last
  end

  def found last_label
    !@last.nil?
  end

  def found_first_label
    !@first.nil?
  end
end
