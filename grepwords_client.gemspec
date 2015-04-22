Gem::Specification.new do |s|
  s.name              = 'grepwords_client'
  s.version           = '0.0.8'
  s.date              = '2015-04-22'
  s.summary           = 'Grepwords API Wrapper'
  s.description       = 'Wraps Grepwords API calls in a gem'
  s.authors           = 'refriedchicken'
  s.email             = 'mike.benner@authoritylabs.com'
  s.files             = Dir.glob("{bin,lib}/**/*") + %w[README.md]
  s.require_paths     = ['lib']
  s.homepage          = ''
  s.rdoc_options      = ['--charset=UTF-8 --main=README.md']
  s.extra_rdoc_files  = ['README.md']

  s.add_dependency(%q<rest-client>, ['>= 1.6.7'])
  s.add_development_dependency(%q<rspec>, ['>= 2.14.1'])
  s.add_development_dependency(%q<simplecov>)
end
