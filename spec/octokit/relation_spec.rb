require 'helper'

describe Octokit::Relation do
  subject { described_class }

  describe ".from_link" do
    it "builds relation from hash" do
      hash = {
        :href   => "/users/1",
        :method => "post"
      }

      rel = subject.from_link(nil, :self, hash)

      expect(rel.name).to                   eql(:self)
      expect(rel.href).to                   eql("/users/1")
      expect(rel.method).to                 eql(:post)
      expect(rel.available_methods.to_a).to match_array([:post])
    end
  end

  describe ".from_links" do
    it "builds multiple rels from multiple methods" do
      index = {
        "comments" => {
          :href   => "/comments",
          :method => "get,post"
        }
      }

      rels = subject.from_links(nil, index)

      expect(rels.size).to eql(1)
      expect(rels.keys).to match_array([:comments])

      expect(rels[:comments]).not_to be_falsey
      rel = rels[:comments]

      expect(rel.href).to                   eql("/comments")
      expect(rel.method).to                 eql(:get)
      expect(rel.available_methods.to_a).to match_array([:get, :post])
      expect(rel.href_template).to          be_kind_of(Addressable::Template)
    end

    it "builds rels from hash" do
      index = {
        "self" => "/users/1"
      }

      rels = subject.from_links(nil, index)

      expect(rels.size).to eql(1)
      expect(rels.keys).to match_array([:self])

      expect(rels[:self]).not_to be_falsey
      rel = rels[:self]

      expect(rel.name).to                   eql(:self)
      expect(rel.href).to                   eql("/users/1")
      expect(rel.method).to                 eql(:get)
      expect(rel.available_methods.to_a).to match_array([:get])
      expect(rel.href_template).to          be_kind_of(Addressable::Template)
    end

    it "builds_rels_from_hash_index" do
      index = {
        "self" => {
          :href => "/users/1"
        }
      }

      rels = subject.from_links(nil, index)

      expect(rels.size).to                  eql(1)
      expect(rels.keys).to                  match_array([:self])

      expect(rels[:self]).not_to be_falsey
      rel = rels[:self]

      expect(rel.name).to                   eql(:self)
      expect(rel.href).to                   eql("/users/1")
      expect(rel.method).to                 eql(:get)
      expect(rel.available_methods.to_a).to match_array([:get])
      expect(rel.href_template).to          be_kind_of(Addressable::Template)
    end

    it "builds_rels_from_nil" do
      rels = subject.from_links(nil, nil)

      expect(rels.size).to eql(0)
      expect(rels.keys).to match_array([])
    end
  end

  context "making API calls" do
    it "provides methods for each supported HTTP method"

    it "supports URI templates"

    it "handles invalid URI"

    it "handles all HTTP methods when not in strict mode"
  end
end

describe Octokit::Relation::Map do
  subject { described_class.new }

  describe "#inspect" do
    it "returns a string with the properties" do
      hash = {
        :href   => '/users/1',
        :method => 'post'
      }

      rel  = Octokit::Relation.from_link(nil, :self, hash)
      subject << rel

      expect(subject.inspect).to eql("{:self_url=>\"/users/1\"}\n")
    end
  end
end
