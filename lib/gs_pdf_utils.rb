require "gs_pdf_utils/version"

module GsPdfUtils
  class GsPdfUtilsError < StandardError; end
  class BadFileType < GsPdfUtilsError; end
  class CommandFailed < GsPdfUtilsError; end
  class ProcessingError < GsPdfUtilsError; end
  class OutOfBounds < GsPdfUtilsError; end

  class << self
    attr_writer :ghostscript_binary
    def ghostscript_binary
      @ghostscript_binary ||= "gs"
    end

    def is_pdf?(file)
      IO.binread(file, 4) == "%PDF"
    end

    def configure
      yield self
    end
  end

  autoload :GsRunner, 'gs_pdf_utils/gs_runner'
  autoload :PdfFile,  'gs_pdf_utils/pdf_file'
end
