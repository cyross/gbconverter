# -*- encoding: utf-8 -*-

require './gbc_logger'
require './gbc_opts'
require './gbc_converter'

if __FILE__ == $0
  logger = GBCLogger.new
  logger.info("=====gamebook convert start=====")

  # 1st: analyze options
  logger.info("[0]analyze options")
  opts = GBCOpts.instance

  # 2nd: split paragraphs
  logger.info("[1]split files")
  files = Dir.glob(opts.idir+"*"+opts.iext)
  print files

  logger.info("=====gamebook convert finish=====")
end
