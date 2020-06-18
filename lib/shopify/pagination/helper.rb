module Shopify
  module Pagination
    module Helper
      def cursor_paginate(items, options = {})
        return if items.blank?

        return unless items.respond_to?(:cursor_pagination)

        res = ["<div class='pagination cursor-based #{options[:pagination_class]}'><span class='button-group'>"]

        additional_params = options.with_indifferent_access[:params] || {}

        if items.cursor_pagination[:previous] || items.cursor_pagination[:next]
          res << link_to(
            raw(I18n.t('views.pagination.previous')),
            url_for(
              additional_params.merge(
                page_info: items.cursor_pagination.dig(:previous, :page_info),
                direction: 'previous',
                limit: items.cursor_pagination.dig(:previous, :limit)
              )
            ),
            class: "button secondary btn btn-default icon-arrow-left #{items.cursor_pagination[:previous].blank? && 'disabled'}"
          )

          res << link_to(
            raw(I18n.t('views.pagination.next')),
            url_for(
              additional_params.merge(
                page_info: items.cursor_pagination.dig(:next, :page_info),
                direction: 'next',
                limit: items.cursor_pagination.dig(:next, :limit)
              )
            ),
            class: "button secondary btn btn-default icon-arrow-right #{items.cursor_pagination[:next].blank? && 'disabled'}"
          )
        end

        res << '</span></div>'

        raw res.join(' ')
      end
    end
  end
end
