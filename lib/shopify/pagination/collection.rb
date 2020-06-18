# coding: utf-8
# frozen_string_literal: true

# @example Paginating products.
#   products = Shopify::Product.all(params: { limit: 25 })
#   products = Shopify::Product.all(params: { since_id: 0, limit: 25 })
#   products = Shopify::Product.all(params: { page_info: "eyJvcmRlciI6ImlkIGFzYyIsImxhc3RfaWQiOjE2MDE2OTE5NzY0OCwibGFzdF92YWx1ZSI6IjE2MDE2OTE5NzY0OCIsImRpcmVjdGlvbiI6Im5leHQifQ", limit: 25 })
class Shopify::Pagination::Collection < ActiveResource::Collection

  alias_method :model, :resource_class

  # Shopify returns this many records by default if no limit is given.
  DEFAULT_LIMIT_VALUE = 50

  ENTRIES_INFO_I18N_KEY = 'helpers.page_entries_info.entry'.freeze

  def response
    @response ||= resource_class&.connection&.response
  end

  def next(params = {})
    params[:since_id] = since_id if since_id && params[:order].blank?
    page(:next, params)
  end
  alias :fetch_next_page :next

  def previous(params = {})
    page(:previous, params)
  end

  def page(direction, params = {})
    return self.class.new([]) if !resource_class || cursor_pagination[direction].blank?

    params = original_params.merge(params)

    if params[:since_id].present? && direction == :next
      params.delete :page_info
    else
      params.merge!(page_info: cursor_pagination.dig(direction, :page_info))
      params.delete :since_id
    end

    collection_got resource_class.all(params: params)
  end

  def since_id
    @since_id ||= last&.id.to_i
  end

  def page_info
    original_params && original_params[:page_info]
  end

  def next_page_info
    cursor_pagination.dig(:next, :page_info)
  end

  def next_page?
    next_page_info.present?
  end

  def collection_got items
    @since_id = items.last&.id

    items
  end

  def cursor_pagination
    return @cursor_pagination if @cursor_pagination.present?

    @cursor_pagination = {}

    return @cursor_pagination if response.header['link'].blank?

    response.header['link'].split(',').each do |link|
      begin
        h = link.scan(/<([^>]+)>|rel="([^"]+)"/).flatten.compact
        query = CGI::parse(URI.parse(h.first).query)
        direction = h.last.to_sym

        # odd, but shopify return previous page link for since_id = 0
        next if direction == :previous && original_params[:since_id].present? && original_params[:since_id].to_i == 0
 
        @cursor_pagination.merge!(
          direction => { link: h.first, limit: query['limit'].first.to_i, page_info: query['page_info'].last }
        )
      rescue => e
        p "cursor_pagination ->",e
      end
    end

    @cursor_pagination
  end
end
