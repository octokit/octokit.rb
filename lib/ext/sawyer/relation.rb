require 'sawyer'

module Patch
  def href(options=nil)
    # Temporary workaround for: https://github.com/octokit/octokit.rb/issues/727
    name.to_s == "ssh" ? @href : super
  end
end

Sawyer::Relation.send(:prepend, Patch)
