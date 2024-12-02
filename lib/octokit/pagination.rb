# frozen_string_literal: true

module Octokit
  # Pagination handling for Octokit Client
  module Pagination
    # Enumerable type for paginating API requests which only makes API requests when needed.
    # PageEnumerator provides an accessor for the total number of pages in a request, and can
    # be configured to fetch a maximum number of pages.
    class PageEnumerator
      include Enumerable

      def initialize(options = {}, &block)
        @fetch = block
        @page_num = 1
        @response = nil
        @max_pages = options.fetch(:max_pages, nil)
        @include_response = !!options.fetch(:include_response, nil)
      end

      def each(&block)
        fetch_next_page unless defined?(@data)

        while @data
          if @include_response
            block.call(@data, @response)
          else
            block.call(@data)
          end

          @page_num += 1
          break if !@max_pages.nil? && @page_num > @max_pages
          break if !@total_pages.nil? && @page_num > @total_pages

          fetch_next_page
        end
      end

      def with_response
        @include_response = true
        self
      end

      def total_pages
        fetch_next_page unless defined?(@total_pages)

        @total_pages || 1
      end

      private

      def fetch_next_page
        @response, @data = @fetch.call(@response)
        @total_pages = parse_total_pages_from_response
      end

      def parse_total_pages_from_response
        last_page_link = @response&.rels&.[](:last)
        return unless last_page_link

        uri = URI.parse(last_page_link.href)
        CGI.parse(uri.query).fetch('page', [1]).first.to_i
      end
    end

    # Make one or more HTTP GET requests, optionally:
    # 1. fetching the next page of results from URL in Link response header based
    #    on value in {#auto_paginate}.
    # 2. returning an enumerable for the data returned by each page based on value in {#paginate}.
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query, header, and pagination (optional) params for request
    # @param block [Block] Block to perform the data concatination of the
    #   multiple requests. The block is called with two parameters, the first
    #   contains the contents of the requests so far and the second parameter
    #   contains the latest response.
    # @return [Sawyer::Resource]
    def paginate(url, options = {}, &block)
      opts = parse_query_and_convenience_headers(options).dup
      pagination_options = opts.delete(:pagination) || {}
      pagination_type = determine_pagination_type(pagination_options)

      if @per_page || pagination_type
        opts[:query][:per_page] ||= @per_page || (pagination_type ? 100 : nil)
      end
      pagination_options[:max_pages] = 1 if pagination_type.nil?

      enumerator = PageEnumerator.new(pagination_options) do |previous_response|
        if previous_response.nil?
          data = request(:get, url, opts)
          next [@last_response, data]
        end

        next [] if previous_response.rels[:next].nil? || rate_limit.remaining.zero?

        @last_response = previous_response.rels[:next].get(headers: opts[:headers])
        [@last_response, response_data_correctly_encoded(@last_response)]
      end
      return enumerator if pagination_type == :enumerable

      auto_paginate_enumerator(enumerator, &block)
    end

    private

    def auto_paginate_enumerator(enumerator, &block)
      enumerator.with_response.reduce(nil) do |accum, (data, response)|
        next data if accum.nil?
        next accum.concat(data) if block.nil?

        block.call(accum, response)
        accum
      end
    end

    # Determine the type of pagination expected by the user.
    # In order of preference:
    # 1. An `auto_paginate` flag set as an API call option: Collect all responses into a single result
    # 2. A `paginate` flag set as an API call option: Return an API page enumerator
    # 3. The client's @auto_paginate flag: Collect all responses into a single result
    # 4. The client's @paginate flag: Return an API page enumerator
    # 5. nil: No pagination
    def determine_pagination_type(pagination_options)
      return :auto if pagination_options.fetch(:auto_paginate, false)
      return :enumerable if pagination_options.fetch(:paginate, false)
      return :auto if @auto_paginate
      return :enumerable if @paginate

      nil
    end
  end
end
