module Octokit

  # Default setup options for preview features
  module Preview

    PREVIEW_TYPES = {
      :branch_protection      => 'application/vnd.github.loki-preview+json'.freeze,
      :migrations             => 'application/vnd.github.wyandotte-preview+json'.freeze,
      :licenses               => 'application/vnd.github.drax-preview+json'.freeze,
      :source_imports         => 'application/vnd.github.barred-rock-preview'.freeze,
      :reactions              => 'application/vnd.github.squirrel-girl-preview'.freeze,
      :repository_invitations => 'application/vnd.github.swamp-thing-preview+json'.freeze,
      :issue_timelines        => 'application/vnd.github.mockingbird-preview+json'.freeze,
      :pages                  => 'application/vnd.github.mister-fantastic-preview+json'.freeze,
      :projects               => 'application/vnd.github.inertia-preview+json'.freeze,
      :traffic                => 'application/vnd.github.spiderman-preview'.freeze,
      :org_membership         => 'application/vnd.github.korra-preview'.freeze,
      :reviews                => 'application/vnd.github.black-cat-preview'.freeze,
      :integrations           => 'application/vnd.github.machine-man-preview+json'.freeze,
      :topics                 => 'application/vnd.github.mercy-preview+json'.freeze
    }

    def ensure_api_media_type(type, options)
      if options[:accept].nil?
        options[:accept] = PREVIEW_TYPES[type]
        warn_preview(type)
      end
      options
    end

    def warn_preview(type)
      octokit_warn <<-EOS
WARNING: The preview version of the #{type.to_s.capitalize} API is not yet suitable for production use.
You can avoid this message by supplying an appropriate media type in the 'Accept' request
header.
EOS
    end
  end
end
