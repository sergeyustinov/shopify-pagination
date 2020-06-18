# coding: utf-8
# frozen_string_literal: true

require 'shopify_api'

module Shopify
  module Pagination
    autoload :Collection, 'shopify/pagination/collection'
    autoload :Helper, 'shopify/pagination/helper'
    autoload :VERSION, 'shopify/pagination/version'
  end
end

ActionView::Base.send :include, Shopify::Pagination::Helper

ShopifyAPI::Base.class_eval do
  # Set the default collection parser.
  self.collection_parser = Shopify::Pagination::Collection
end
