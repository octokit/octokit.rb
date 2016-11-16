module Sawyer
  class Relation
    def href(options=nil)
      return @href if @href_template.nil?
      return @href if name.to_s == "ssh"

      @href_template.expand(options || {}).to_s
    end
  end
end

