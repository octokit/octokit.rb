module Octokit

  # Default setup options for preview features
  module Preview

    PREVIEW_TYPES = {
      :branch_protection => 'application/vnd.github.loki-preview+json'.freeze,
      :migrations        => 'application/vnd.github.wyandotte-preview+json'.freeze,
      :licenses          => 'application/vnd.github.drax-preview+json'.freeze,
      :source_imports    => 'application/vnd.github.barred-rock-preview'.freeze,
    }

    def ensure_api_media_type(type, options)
      if options[:accept].nil?
        options[:accept] = PREVIEW_TYPES[type]
        warn_preview(type)
      end
      options
    end

    def warn_preview(type)
      warn <<-EOS
WARNING: The preview version of the #{type.to_s.capitalize} API is not yet suitable for production use.
You can avoid this message by supplying an appropriate media type in the 'Accept' request
header.
EOS
    end
  end
end
