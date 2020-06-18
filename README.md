# Shopify::Pagination

## Installation

Add this line to your application's Gemfile:

    gem 'shopify-pagination', git: 'https://github.com/sergeyustinov/shopify-pagination.git'

## Usage

Just add the gem to your Gemfile, and all of your Shopify 
resources will be paginatable.

Example:

```ruby
ShopifyAPI::Session.temp(domain, token) do
  @products = ShopifyAPI::Product.all(params: { since_id: 0, limit: 250 })
  @products = ShopifyAPI::Product.all(params: { since_id: 0, limit: 250 })
  @products = ShopifyAPI::Product.all(params: { page_info: "eyJvcmRlciI6ImlkIGFzYyIsImxhc3RfaWQiOjE2MDE2OTE5NzY0OCwibGFzdF92YWx1ZSI6IjE2MDE2OTE5NzY0OCIsImRpcmVjdGlvbiI6Im5leHQifQ", limit: 250 })
end
```

Then you could paginate the products in the view as you would with any other 
model:

```erb
<%= cursor_paginate @products, pagination_class: 'pagination-centered', params: { title: params[:title] }  %>
```
