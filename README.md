# GsPdfUtils

This gem provides some simple pdf utilities based on Ghostscript.

Currently it provides methods for detecting pdf files by magic, counting pdf pages
and extracting single or all pages from a pdf.

It is less resource hungry and faster than eg. pdftk or imagemagick for the tasks provided.

It's still in alpha state and was freshly extracted from a project and has no spec coverage,
still it might suite your needs.

## Installation

Add this line to your application's Gemfile:

    gem 'gs_pdf_utils', :git => "https://github.com/fbuenemann/gs_pdf_utils"

And then execute:

    $ bundle

Due to it's early state, gem is not currently released on rubygems.

## Usage

```ruby
pdf = GsPdfUtils::PdfFile.new "test.pdf"
# get page count
pdf.pages
# extract a page to page1.pdf
pdf.extract_page(1, "page1.pdf")
# extract all pages to separate pdfs (page-1.pdf, page-2.pdf, ...)
pdf.extract_pages("page-%d.pdf")
# check if file is a pdf, by checking magic bytes
GsPdfUtils.is_pdf? "test.pdf"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
