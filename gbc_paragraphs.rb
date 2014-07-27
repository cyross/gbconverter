# -*- encoding: utf-8 -*-

require './gbc_logger'

class Paragraphs
  def initialize(textformatter, first_label = 1)
    @logger = GBCLogger.new
    @text_formatter = textformatter
    @regexp = @text_formatter.regexp
    @first_label = first_label
    @fixed_labels = []
    @paragraphs = {}
    @label = nil
    @shuffled_labels = {}
    @reverse_shuffled_labels = {}
    @replace_labels = {}
    @count = {}
    @found_last_label = false
  end

  def [](label)
    @paragraphs[label]
  end

  def add(label, fixed_label = false)
    if @fixed_labels.include?(label) or @paragraphs.include?(label)
      @logger.error("指定した先頭パラグラフのラベルはすでに存在しています : #{label}")
      exit
    elsif @paragraphs[@label] and @paragraphs[@label].empty?
      @logger.error("パラグラフの本文が空です : #{label}")
      exit
    end
    @label = label
    @found_last_label = (@regexp[:last].match(label) != nil)
    if fixed_label
      @fixed_labels << @label
    elsif @fixed_labels.empty?
      @logger.error("先頭のラベルは固定パラグラフでのみ指定できます : #{@label}")
      exit
    elsif @regexp[:last].match(label)
      @logger.error("★LAST★ラベルは固定パラグラフでのみ指定できます : #{label}")
      exit
    end
    @paragraphs[@label] = []
  end

  def append(line)
    return unless @label
    @paragraphs[@label] << line
  end

  def <<(line)
    append(line)
  end

  def first_paragraph
    @first_label
  end

  def last_paragraph
    @first_label + @paragraphs.size - 1
  end

  def size
    @paragraphs.size
  end

  def paragraphs
    @paragraphs.keys
  end

  def replace_paragraph_number(old_label, new_label)
    @replace_labels[old_label] = new_label
    paragraph = @paragraphs[old_label]
    @paragraphs.delete(old_label)
    @paragraphs[new_label] = paragraph
    if @fixed_labels.include?(old_label)
      @fixed_labels.delete(old_label)
      @fixed_labels << new_label
    end
  end

  def shuffle
    labels = paragraphs
    @fixed_labels.each{|fp| labels.delete(fp) }
    (first_paragraph..last_paragraph).each{|pnum|
      pnum = pnum.to_s
      if @fixed_labels.include?(pnum)
        labels.delete(pnum)
        @shuffled_labels[pnum] = pnum
        @reverse_shuffled_labels[pnum] = pnum
      else
        nnum = labels.sample
        labels.delete(nnum)
        @shuffled_labels[pnum] = nnum
        @reverse_shuffled_labels[nnum] = pnum
      end
    }
    unless labels.empty?
      @logger.fatal("数が連続していません\n#{paragraphs}\n#{fixed_labels}")
      exit
    end
  end

  def replace_link(regexp)
    @paragraphs.each_key{|key|
      found = false
      @paragraphs[key].map!{|line|
        if regexp.match(line)
          base_name = $1
          num = nil
          if @replace_labels.include?(base_name)
            num = @replace_labels[base_name]
            found = true
          elsif not @reverse_shuffled_labels.include?(base_name)
            @logger.error("指定したラベルが見つかりません : #{base_name}")
            exit
          else
            num = @reverse_shuffled_labels[base_name]
            found = true
          end
          line.gsub!(regexp, num)
        end
        line
      }
      @logger.warn("本文中にリンクが見つかりません : #{key}") unless found
    }
  end

  def replace_text(replaces, regexp)
    @paragraphs.each_key{|key|
      @paragraphs[key].map!{|line|
        while regexp.match(line)
          base_name = $1
          value = nil
          if not replaces.include?(base_name)
            @logger.error("指定した文字列の定義が見つかりません : #{base_name}")
            exit
          end
          line.gsub!(%r|#\{\{#{base_name}\}\}|, replaces[base_name])
        end
        line
      }
    }
  end

  def label_check
    @logger.warn("最後のパラグラフのラベルが見つかりませんでした") unless @found_last_label
  end

  def number_check
  end

  def output
    @shuffled_labels.each_key{|key|
      yield key, @paragraphs[@shuffled_labels[key]]
    }
  end

  attr_reader :shuffled_paragraphs, :reverse_shuffled_paragraphs
end
