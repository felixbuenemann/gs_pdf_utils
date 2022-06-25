# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gs_pdf_utils/version'

Gem::Specification.new do |gem|
  gem.name          = "gs_pdf_utils"
  gem.version       = GsPdfUtils::VERSION
  gem.authors       = ["Felix Buenemann"]
  gem.email         = ["buenemann@louis.info"]
  gem.description   = %q{The gs_pdf_util gem wraps around ghostscript to provide simple pdf processing.}
  gem.summary       = %q{Ghostscript PDF Utilities}
  gem.homepage      = "https://github.com/felixbuenemann/gs_pdf_utils"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
