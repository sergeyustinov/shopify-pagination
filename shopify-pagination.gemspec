# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'shopify/pagination/version'

Gem::Specification.new do |spec|
  spec.name = 'shopify-pagination'
  spec.version = Shopify::Pagination::VERSION
  spec.authors = ['Sergei Ustinov']
  spec.email = ['se.ustinov@gmail.com']
  spec.homepage = 'https://github.com/sergeyustinov/shopify-pagination.git'
  spec.summary = %q{Provides shopify_api with cursor based pagination support}

  spec.bindir = 'exe'
  spec.require_paths = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test)/})
  end

  spec.executables = spec.files.grep(%r{^#{spec.bindir}/}) do |file|
    File.basename(file)
  end

  spec.add_dependency 'shopify_api' # todo add version

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
