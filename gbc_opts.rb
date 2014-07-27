require 'optparse'
require 'singleton'

class GBCOpts
  include Singleton

  def initialize
    @idir = "./"
    @odir = "./"
    @iext = ".txt"
    @splitter = "|"

    opt = OptionParser.new
    opt.on('-i', '--input-dir=[VAL]', "input file / default:#{@idir}"){|v| @idir = v }
    opt.on('-o', '--output-dir=[VAL]', "output files directory  / default:#{@odir}"){|v| @odir = v }
    opt.on('-e', '--ext=[VAL]', "input files glob extension / default:#{@iext}"){|v| @iext = v }
    opt.on('-s', '--splitter=[VAL]', "label inner splitter / default:#{@splitter}"){|v| @splitter = v }

    opt.parse!(ARGV)
  end

  attr_reader :idir, :odir, :iext, :splitter
end
