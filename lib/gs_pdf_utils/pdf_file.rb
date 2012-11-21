# encoding: utf-8
module GsPdfUtils
  class PdfFile
    NULL_DEVICE = RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL' : '/dev/null'

    def initialize(pdf_file, ghostscript_binary = "gs")
      unless GsPdfUtils.is_pdf? pdf_file
        raise BadFileType, "#{pdf_file} does not appear to be a PDF", caller
      end
      @file = pdf_file
      @gs = ghostscript_binary
    end

    def pages
      @pages ||= count_pages
    end

    def extract_page(page, targetfile)
      page = page.to_i
      if page < 1 || page > pages
        raise OutOfBounds, "page #{page} is out of bounds (1..#{pages})", caller
      end
      cmd = "#{@gs.shellescape} -q -sDEVICE=pdfwrite -dSAFER -dFirstPage=#{page} -dLastPage=#{page} -o #{targetfile.shellescape} #{@file.shellescape} 2>#{NULL_DEVICE}"
      output = `#{cmd}`
      if $?.to_i > 0
        raise CommandFailed, "command #{cmd} failed with output: #{output}", caller
      end
      if File.size(targetfile) == 0
        raise ProcessingError, "extracted page is 0 bytes", caller
      end
      targetfile
    end

    # targetfile_template = "test-%d.pdf"
    def extract_pages(targetfile_template)
      cmd = "#{@gs.shellescape} -q -sDEVICE=pdfwrite -dSAFER -o #{targetfile_template.shellescape} #{@file.shellescape} 2>#{NULL_DEVICE}"
      output = `#{cmd}`
      if $?.to_i > 0
        raise CommandFailed, "command #{cmd} failed with output: #{output}", caller
      end
      targetfiles = (1..pages).map {|page| sprintf(targetfile_template, page)}
    end

    private

    def count_pages
      cmd = "#{@gs.shellescape} -q -dNODISPLAY -c \"(#{@file.shellescape}) (r) file runpdfbegin pdfpagecount = quit\" 2>#{NULL_DEVICE}"
      output = `#{cmd}`
      if $?.to_i > 0
        raise CommandFailed, "command #{cmd} failed with output: #{output}", caller
      end
      num_pages = output.to_i
      if num_pages == 0
        raise ProcessingError, "could not determine number of pages", caller
      end
      num_pages
    end

  end
end
