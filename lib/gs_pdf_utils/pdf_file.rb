# encoding: utf-8
require 'shellwords'

module GsPdfUtils
  class PdfFile
    def initialize(pdf_file, gs_runner = GsRunner.new)
      unless GsPdfUtils.is_pdf? pdf_file
        raise BadFileType, "#{pdf_file} does not appear to be a PDF", caller
      end
      @file = pdf_file
      @gs_runner = gs_runner
    end

    def pages
      @pages ||= count_pages
    end

    def extract_page(page, targetfile)
      extract_page_range(page..page, targetfile)
    end

    def extract_page_range(page_range, targetfile)
      page_from = page_range.first
      page_to = page_range.last
      if page_from < 1 || page_from > page_to || page_to > pages
        raise OutOfBounds, "page range #{page_range} is out of bounds (1..#{pages})", caller
      end
      @gs_runner.run "-sDEVICE=pdfwrite -dSAFER -dFirstPage=#{page_from} -dLastPage=#{page_to} -o #{targetfile.shellescape} #{@file.shellescape}"
      if File.size(targetfile) == 0
        raise ProcessingError, "extracted page is 0 bytes", caller
      end
      targetfile
    end

    # targetfile_template = "test-%d.pdf"
    def extract_pages(targetfile_template)
      @gs_runner.run "-sDEVICE=pdfwrite -dSAFER -o #{targetfile_template.shellescape} #{@file.shellescape}"
      targetfiles = (1..pages).map {|page| sprintf(targetfile_template, page)}
    end

    def append_files(*pdf_files, targetfile)
      pdf_files.each do |pdf_file|
        unless GsPdfUtils.is_pdf? pdf_file
          raise BadFileType, "#{pdf_file} does not appear to be a PDF", caller
        end
      end
      @gs_runner.run "-sDEVICE=pdfwrite -dSAFER -o #{targetfile.shellescape} #{@file.shellescape} #{pdf_files.map(&:shellescape).join ' '}"
      targetfile
    end

    private

    def count_pages
      output = @gs_runner.run_with_output "-dNODISPLAY -c \"(#{@file.shellescape}) (r) file runpdfbegin pdfpagecount = quit\""
      num_pages = output.to_i
      if num_pages == 0
        raise ProcessingError, "could not determine number of pages", caller
      end
      num_pages
    end

  end
end
