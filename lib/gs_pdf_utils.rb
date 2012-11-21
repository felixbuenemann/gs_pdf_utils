require "gs_pdf_utils/version"

module GsPdfUtils
  class GsPdfUtilsError < StandardError; end
  class BadFileType < GsPdfUtilsError; end
  class CommandFailed < GsPdfUtilsError; end
  class ProcessingError < GsPdfUtilsError; end
  class OutOfBounds < GsPdfUtilsError; end

  class << self
    def is_pdf?(file)
      IO.binread(file, 4) == "%PDF"
    end
  end

  autoload :PdfFile, 'gs_pdf_utils/pdf_file'
end
