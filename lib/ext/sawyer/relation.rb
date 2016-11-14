module Sawyer
  class Relation
    def href(options=nil)
      return @href if @href_template.nil?
      @href_template.expand(options || {}).to_s
    rescue Addressable::URI::InvalidURIError
      @href
    end
  end
end

