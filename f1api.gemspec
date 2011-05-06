# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = %q{f1api}
  s.version = "0.9.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jesse Dearing"]
  s.date = %q{2011-05-06}
  s.description = %q{Consumes the Fellowship One API in your apps using ActiveResource.  Implements 2nd party credentials-based authenticaion and full OAuth implementation. }
  s.email = %q{jesse.dearing@activenetwork.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = `git ls-files`.split("\n")
  s.homepage = %q{http://github.com/jessedearing/f1api}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = %q{Consume the Fellowship One API in your apps using ActiveResource}

  if s.respond_to? :specification_version
    s.specification_version = 3
    s.add_runtime_dependency('oauth', "= 0.4.4")
    s.add_runtime_dependency('activeresource', ">= 0")
    s.add_runtime_dependency('oauth', "= 0.4.4")
    s.add_development_dependency('mocha', ">= 0")
    s.add_runtime_dependency('activeresource', ">= 0")
  end
end

