require_relative '../lib/spike'

# TODO:
# - for a subresource normalize route params to use url instead of repo + base resource
# - fix @return (right now it's inverted to check for singular, not collection)

describe Spike do
  context "Spike::Resource" do
    it "infers a collection resource" do
      resource = Spike::Resource.new("/apples")
      expect(resource.name).to eq("apples")
    end

    it "infers a singular resource" do
      resource = Spike::Resource.new("/apples/:id")
      expect(resource.name).to eq("apple")
    end

    it "infers the name of a singular subresource" do
      resource = Spike::Resource.new("/desserts/:id/toppings/:topping_id")
      expect(resource.name).to eq("dessert_topping")
    end

    it "infers the name of a collection subresource" do
      resource = Spike::Resource.new("/desserts/:id/toppings")
      expect(resource.name).to eq("dessert_toppings")
    end
  end

  context "Spike::Routes normalization" do
    it "converts the camelCase documentation url key to snake case" do
      definition = Spike::Routes.new('{"documentationUrl": "http://example.com/meals/#cook-a-meal"}').definition
      expect(definition.documentation_url).to eq("http://example.com/meals/#cook-a-meal")
    end

    it "transforms :id parameter to :resource_id" do
      definition = Spike::Routes.new('{"path": "/meals/:id", "params": [{"name": "id"}]}').definition
      expect(definition.path).to eq("/meals/:meal_id")
    end

    it "transforms id parameter to resource_id" do
      definition = Spike::Routes.new('{"path": "/meals/:id", "params": [{"name": "id"}]}').definition
      expect(definition.params.first.name).to eq("meal_id")
    end

    it "converts type of id params to integer" do
      definition = Spike::Routes.new('{"params": [{"name": "meal_id", "type": "string"}]}').definition
      expect(definition.params.first.type).to eq("integer")
    end

    it "gets rid of owner param" do
      definition = Spike::Routes.new('{"params": [{"name": "owner"}]}').definition
      expect(definition.params.size).to eq(0)
    end

    it "renames method to verb" do
      definition = Spike::Routes.new('{"method": "PATCH"}').definition
      expect(definition.verb).to eq("PATCH")
    end

    it "gives :repo param a description" do
      definition = Spike::Routes.new('{"params": [{"name": "repo", "description": ""}]}').definition
      expect(definition.params.first.description).to eq("A GitHub repository")
    end

    it "gives provides a fallback description for id params" do
      json = '{"params": [{"name": "hand_roll_id", "description": ""}, {"name": "nigiri_id", "description": "pure deliciousness"}]}'
      definition = Spike::Routes.new(json).definition
      expect(definition.params[0].description).to eq("The ID of the hand roll")
      expect(definition.params[1].description).to eq("pure deliciousness") # doesn't clobber existing descriptions
    end

    it "replaces repo and resource with resource_url for subresources" do
      definition = Spike::Routes.new('{"path": "/meals/:id/sides", "params": [{"name": "repo"}, {"name": "id"}]}').definition
      expect(definition.params.length).to eq(1)
      param = definition.params.first
      expect(param.name).to eq("meal_url")
      expect(param.required).to be(true)
      expect(param.description).to eq("A URL for a meal resource.")
      expect(param.type).to eq("string")
    end
  end

  context Spike::Endpoint do
    context "the method definition" do
      it "is named the singular of the resource for the singular GET endpoint" do
        definition = Spike::Routes.new('{"method": "GET", "path": "/meals/:id"}').definition
        endpoint = Spike::Endpoint.new(definition, directory: "meals")
        expect(endpoint.method_name).to eq("meal")
      end

      it "is named the plural of the resource for list GET endpoints" do
        definition = Spike::Routes.new('{"method": "GET", "path": "/meals"}').definition
        endpoint = Spike::Endpoint.new(definition, directory: "meals")
        expect(endpoint.method_name).to eq("meals")
      end

      it "is prefixed with 'create' for the POST endpoint" do
        definition = Spike::Routes.new('{"method": "POST", "path": "/meals"}').definition
        endpoint = Spike::Endpoint.new(definition, directory: "meals")
        expect(endpoint.method_name).to eq("create_meal")
      end

      it "is prefixed with the singular resource for subresources" do
        definition = Spike::Routes.new('{"method": "GET", "path": "/meals/:id/courses/:course_id"}').definition
        endpoint = Spike::Endpoint.new(definition, directory: "meals")
        expect(endpoint.method_name).to eq("meal_course")
      end
    end

    it "defines positional arguments by default" do
      json = '{"params": [{"name": "a", "required": true}, {"name": "b", "required": true}]}'
      definition = Spike::Routes.new(json).definition
      endpoint = Spike::Endpoint.new(definition, directory: "meals")
      expect(endpoint.parameters).to eq("a, b, options = {}")
    end

    it "defines kwarg arguments when specified" do
      json = '{"params": [{"name": "a", "required": true}, {"name": "b", "required": true}]}'
      definition = Spike::Routes.new(json).definition
      endpoint = Spike::Endpoint.new(definition, directory: "meals", parameterizer: Spike::Endpoint::KwargsParameterizer)
      expect(endpoint.parameters).to eq("a:, b:, **options")
    end

    it "sorts endpoints based on priority" do
      get    = Spike::Endpoint.new(Spike::Routes.new('{"method": "GET", "path": "/meals/:id", "name": "get"}').definition, directory: "meals")
      list   = Spike::Endpoint.new(Spike::Routes.new('{"method": "GET", "path": "/meals", "name": "list"}').definition, directory: "meals")
      create = Spike::Endpoint.new(Spike::Routes.new('{"method": "POST", "path": "/meals", "name": "create"}').definition, directory: "meals")
      actual = [create, list, get].sort_by(&:priority).map {|endpoint| endpoint.definition.name}
      expect(actual).to eq(["get", "list", "create"])
    end
  end

  context Spike::API do
    it "determines the module name based on the dirname for the routes JSON file" do
      api = Spike::API.new("path/to/meals/")
      expect(api.namespace).to eq("Meals")
    end

    it "determines the base documentation URL given a containing endpoint" do
      definition = Spike::Routes.new('{"documentationUrl": "http://example.com/meals/#cook-a-meal"}').definition
      endpoint = Spike::Endpoint.new(definition)
      api = Spike::API.new("path/to/meals/", endpoints: [endpoint])
      expect(api.documentation_url).to eq("http://example.com/meals/")
    end
  end
end
