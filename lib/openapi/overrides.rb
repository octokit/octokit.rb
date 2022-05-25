def upload_release_asset(repo, release_id, data, options = {})
  file = data.respond_to?(:read) ? data : File.new(data, "rb")
  unless options[:content_type]
    begin
      require 'mime/types'
      if mime_type = MIME::Types.type_for(file.path).first
        options[:content_type] = mime_type.content_type
      end
    rescue LoadError
      msg = "Please pass content_type or install mime-types gem to guess content type from file"
      raise Octokit::MissingContentType.new(msg)
    end
  end
  unless name = options[:name]
    name = File.basename(file.path)
  end
  upload_url = release(repo, release_id).rels[:upload].href_template.expand(:name => name)

  request :post, upload_url, file.read, parse_query_and_convenience_headers(options)
ensure
  file.close if file
end
