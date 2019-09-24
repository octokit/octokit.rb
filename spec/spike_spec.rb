require_relative '../lib/spike'

describe Spike do
  context Spike::Endpoint do
    it "defines singular? as true if path ends with an id", focus: true do
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "/meals/{meal_id}", nil), nil, nil))
      expect(endpoint.singular?).to eq(true)
    end

    it "defines singular? as false if path doesn't end with an id" do
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "/meals/status", nil), nil, nil))
      expect(endpoint.singular?).to eq(false)
    end

    it "defines api_path to replace required param variables" do
      json = {"parameters"=> [{"name"=>"meal_id", "required"=>true}, {"name"=>"repo", "required"=>false}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "/{repo}/meals/{meal_id}", json), "get", {}))
      expect(endpoint.api_path).to eq("/{repo}/meals/\#{meal_id}")
    end
    
    it "defines required_params to ignore owner and accept" do
      json = {"parameters"=> [{"name"=>"owner", "required"=>true}, {"name"=>"accept"}, {"name"=>"meal_id", "required"=>true}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "/{repo}/meals/{meal_id}", json), "get", {}))
      expect(endpoint.required_params.count).to eq(1)
      expect(endpoint.required_params.first.name).to eq("meal_id")
    end

    it "defines required_params to include params from request_body in POST requests" do
      json = {"parameters"=> [{"name"=>"owner", "required"=>true}],
             "requestBody"=> {"content"=> {"application/json"=> {"schema"=> {"properties"=> {"meal_id"=> {}}, "required"=> ["meal_id"]}}}}}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "post", json))
      expect(endpoint.required_params.count).to eq(1)
      expect(endpoint.required_params.first.name).to eq("meal_id")
    end

    it "defines optional_params to include params from request_body in POST requests" do
      json = {"requestBody"=> {"content"=> {"application/json"=> {"schema"=> {"properties"=> {"meal_id"=> {}, "meal_option"=> {}}, "required"=> ["meal_id"]}}}}}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "post", json))
      expect(endpoint.optional_params.count).to eq(1)
      expect(endpoint.optional_params.first.name).to eq("meal_option")
    end

    it "defines parameter_type for repos as all possible repo types" do
      json = {"parameters"=> [{"name"=>"repo", "required"=>true}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json))
      expect(endpoint.parameter_type(endpoint.required_params.first)).to eq("[Integer, String, Repository, Hash]")
    end

    it "defines parameter_type otherwise as given value capitalized" do
      json = {"parameters"=> [{"name"=>"meal_id", "required"=>true, "schema"=> {"type"=>"string"}}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json))
      expect(endpoint.parameter_type(endpoint.required_params.first)).to eq("[String]")
    end

    it "defines parameter_description as a set repo description" do
      json = {"parameters"=> [{"name"=>"repo", "required"=>true}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json))
      expect(endpoint.parameter_description(endpoint.required_params.first)).to eq("A GitHub repository")
    end

    it "defines parameter_description as a set id description" do
      json = { "parameters"=> [{"name"=>"meal_id", "required"=>true}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json))
      expect(endpoint.parameter_description(endpoint.required_params.first)).to eq("The ID of the meal")
    end

    it "defines parameter_description otherwise as the given description" do
      json = {"parameters"=> [{"name"=>"meal_status", "description"=>"The status of the meal", "required"=>true}]}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json))
      expect(endpoint.parameter_description(endpoint.required_params.first)).to eq("The status of the meal")
    end

    it "prefixes the method definition of POST endpoints with 'create'" do
      json = { "operationId"=> "repos/get-meal" }
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "post", json))
      expect(endpoint.method_name).to eq("create_meal")
    end

     it "defines positional arguments by default" do
       json = {"parameters"=> [{"name"=> "a", "required"=> true}, {"name"=> "b", "required"=> true}]}
       endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "post", json))
       expect(endpoint.parameters).to eq("a, b, options = {}")
     end
 
     it "defines kwarg arguments when specified" do
       json = {"parameters"=> [{"name"=> "a", "required"=> true}, {"name"=> "b", "required"=> true}]}
       endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "post", json), parameterizer: Spike::Endpoint::KwargsParameterizer)
       expect(endpoint.parameters).to eq("a:, b:, **options")
     end
  end

  context Spike::API do
    it "determines the module name based on the dirname for the routes JSON file" do
      api = Spike::API.new("path/to/meals/")
      expect(api.namespace).to eq("Meals")
    end

    it "determines the base documentation URL given a containing endpoint" do
      json = { "externalDocs" => { "url" => "http://example.com/meals/#cook-a-meal" }}
      endpoint = Spike::Endpoint.new(OasParser::Endpoint.new(nil, nil, json))
      api = Spike::API.new("path/to/meals/", endpoints: [endpoint])
      expect(api.documentation_url).to eq("http://example.com/meals/")
    end
  end
end
