# encoding: utf-8
require 'rbconfig'

module GsPdfUtils
  class GsRunner
    NULL_DEVICE = RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL' : '/dev/null'
    COMMON_ARGS = "-q"

    def initialize(ghostscript_binary = GsPdfUtils.ghostscript_binary, common_args = COMMON_ARGS)
      @gs = ghostscript_binary
      @common_args = common_args
    end

    def run(args)
      run_with_output(args)
      nil
    end

    def run_with_output(args)
      cmd = build_gs_command(args)
      output = `#{cmd}`
      if $?.to_i > 0
        raise CommandFailed, "command #{cmd} failed with output: #{output}", caller
      end
      output
    end

    private

    def build_gs_command(args)
      cmd = "#{@gs.shellescape} #{@common_args} #{args} 2>#{NULL_DEVICE}"
    end
  end
end
