# -*- encoding: utf-8 -*-

require './gbc_logger'
require './gbc_paragraph'

class GBConverter
  # コンバータに必要なもの
  # knife: パラグラフを切り分け、Paragraphオブジェクトを作成
  # analizer: パラグラフの内容を解析
  # preprocessor: メイン処理前に必要な処理を施す
  # formatter: パラグラフ番号の割り振りなど、メイン処理
  # postprocessor: メイン処理が終わった後に必要な処理を施す
  # printer: パラグラフを出力
  def initialize(knife, analizer: nil, preprocessor: nil, formatter: nil, postprocessor: nil, printer: nil)
    @logger = GBCLogger.new
    @knife = knife
    @analizer = analizer
    @preprocessor = preprocessor
    @formatter = formatter
    @postprocessor = postprocessor
    @printer = priner
    @lines = lines
    @text_formatter = textformatter
    @paragraphs = Paragraphs.new(textformatter)
    @replaces = Replaces.new()
  end

  def knife(text_files)

  end

  def analyze
    return unless @analizer
    @lines.each{|line| @text_formatter.analyze(line, @paragraphs, @replaces) }
    @logger.info("paragraphs: #{@paragraphs.size}")
    @text_formatter.replace_last_paragraph(@paragraphs)
  end

  def label_check
    @paragraphs.label_check
    @logger.info("complete!")
  end

  def shuffle
    @paragraphs.shuffle
  end

  def replace
    @text_formatter.replace_link(@paragraphs)
    @text_formatter.replace_text(@paragraphs, @replaces)
  end

  def number_check
    @paragraphs.number_check
    @logger.info("complete!")
  end

  def convert
    @logger.info("******start analyze")
    analyze
    @logger.info("******finish analyze")
    @logger.info("******start label check")
    label_check
    @logger.info("******finish label check")
    @logger.info("******start shuffle")
    shuffle
    @logger.info("******finish shuffle")
    @logger.info("******start replace")
    replace
    @logger.info("******finish replace")
    @logger.info("******start number check")
    number_check
    @logger.info("******finish number check")
  end

  def output(f_out)
    @text_formatter.output(f_out, @paragraphs)
  end
end
