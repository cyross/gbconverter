# -*- encoding: utf-8 -*-

require './gbc_logger'

class TextFormatter
  def initialize
    @logger = GBCLogger.new
    @regexp = {
      define: %r|^\*([^:]+):([^\r\n]+)|,
      paragraph: %r|^●([^\r\n]+)|,
      fixed: %r|^●●([^\r\n]+)|,
      last: %r|^★LAST★|,
      link: %r|##([^#]+)##|,
      replace: %r|#\{{2}([^\}]+)\}{2}|
    }
  end

  def analyze(line, paragraphs, replaces)
    if @regexp[:define].match(line)
      label = $1
      str = $2
      @logger.info("got define: #{label} -> #{str}")
      replaces[label] = str
    elsif @regexp[:fixed].match(line)
      label = $1
      @logger.info("got fixed label: #{label}")
      paragraphs.add(label, true)
    elsif @regexp[:paragraph].match(line)
      label = $1
      @logger.info("got label: #{label}")
      paragraphs.add(label)
    else
      paragraphs << line
    end
  end

  def replace_last_paragraph(paragraphs)
    paragraph_names = paragraphs.paragraphs
    paragraph_names.each{|name|
      if @regexp[:last].match(name)
        label = paragraphs.last_paragraph.to_s
        @logger.info("last paragraph : #{label}")
        paragraphs.replace_paragraph_number(name, label)
        return
      end
    }
  end

  def replace_link(paragraphs)
    paragraphs.replace_link(@regexp[:link])
  end

  def replace_text(paragraphs, replaces)
    paragraphs.replace_text(replaces, @regexp[:replace])
  end

  def output(f_out, paragraphs)
    paragraphs.output{|num, bodies| f_out.puts ["●#{num}", bodies.join("")].join("\n") }
  end

  attr_reader :regexp
end

