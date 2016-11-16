require 'sawyer'

module Patch
  def href(options=nil)
    # see: octokit/octokit.rb#727
    name.to_s == "ssh" ? @href : super
  end
end

Sawyer::Relation.send(:prepend, Patch)

