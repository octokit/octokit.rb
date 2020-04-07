require_relative '../lib/openapi_client_generator'

describe OpenAPIClientGenerator do
  context OpenAPIClientGenerator::Endpoint do
    it "defines singular? as true if no response content" do
      json = {"parameters"=> [{"name"=>"owner", "required"=>true}], "responses"=> {"200"=> {"description"=>"no content"}}}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "post", json), [])
      expect(endpoint.singular?).to eq(true)
    end

    it "defines singular? as true if response is not an array type and no per page param" do
      json = {"parameters"=> [{"name"=>"owner", "required"=>true}], "responses"=> {"200"=> {}}}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json), [])
      expect(endpoint.singular?).to eq(true)
    end

    it "defines singular? as false if per page parameter" do
      json = {"parameters"=> [{"name"=>"per_page"}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json), [])
      expect(endpoint.singular?).to eq(false)
    end

    it "defines api_path to replace required param variables" do
      json = {"parameters"=> [{"name"=>"meal_id", "required"=>true}, {"name"=>"repo", "required"=>false}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "/{repo}/meals/{meal_id}", json), "get", {}), [])
      expect(endpoint.api_path).to eq("{repo}/meals/\#{meal_id}")
    end

    it "defines required_params to ignore owner and accept" do
      json = {"parameters"=> [{"name"=>"owner", "required"=>true}, {"name"=>"accept"}, {"name"=>"meal_id", "required"=>true}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "/{repo}/meals/{meal_id}", json), "get", {}), [])
      expect(endpoint.required_params.count).to eq(1)
      expect(endpoint.required_params.first.name).to eq("meal_id")
    end

    it "defines required_params to include params from request_body in POST requests" do
      json = {"parameters"=> [{"name"=>"owner", "required"=>true}],
             "requestBody"=> {"content"=> {"application/json"=> {"schema"=> {"properties"=> {"meal_id"=> {}}, "required"=> ["meal_id"]}}}}}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "post", json), [])
      expect(endpoint.required_params.count).to eq(1)
      expect(endpoint.required_params.first.name).to eq("meal_id")
    end

    it "defines optional_params to include params from request_body in POST requests" do
      json = {"requestBody"=> {"content"=> {"application/json"=> {"schema"=> {"properties"=> {"meal_id"=> {}, "meal_option"=> {}}, "required"=> ["meal_id"]}}}}}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "post", json), [])
      expect(endpoint.optional_params.count).to eq(1)
      expect(endpoint.optional_params.first.name).to eq("meal_option")
    end

    it "defines parameter_type for repos as all possible repo types" do
      json = {"parameters"=> [{"name"=>"repo", "required"=>true}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json), [])
      expect(endpoint.parameter_type(endpoint.required_params.first)).to eq("[Integer, String, Repository, Hash]")
    end

    it "defines parameter_type otherwise as given value capitalized" do
      json = {"parameters"=> [{"name"=>"meal_id", "required"=>true, "schema"=> {"type"=>"string"}}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json), [])
      expect(endpoint.parameter_type(endpoint.required_params.first)).to eq("[String]")
    end

    it "defines parameter_description as a set repo description" do
      json = {"parameters"=> [{"name"=>"repo", "required"=>true}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json), [])
      expect(endpoint.parameter_description(endpoint.required_params.first)).to eq("A GitHub repository")
    end

    it "defines parameter_description as a set id description" do
      json = { "parameters"=> [{"name"=>"meal_id", "required"=>true}]}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json), [])
      expect(endpoint.parameter_description(endpoint.required_params.first)).to eq("The ID of the meal")
    end

    it "defines parameter_description otherwise as the given description" do
      # json = {"parameters"=> [{"name"=>"meal_status", "description"=>"The status of the meal", "required"=>true}]}
      # endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, nil, {}), "get", json))
      # expect(endpoint.parameter_description(endpoint.required_params.first)).to eq("The status of the meal")
    end

    it "defines the method name of POST endpoints with underscores" do
      json = { "operationId"=> "repos/create-meal",
               "responses"=> {"200"=>{}}}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "post", json), [])
      expect(endpoint.method_name).to eq("create_meal")
    end

    it "prefixes the method name of DELETE endpoints with the respective term" do
      json = { "operationId"=> "repos/disable-meal-status",
               "responses"=> {"200"=>{}}}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "delete", json), [])
      expect(endpoint.method_name).to eq("disable_meal_status")
    end

     it "defines positional arguments by default" do
       json = {"parameters"=> [{"name"=> "a", "required"=> true}, {"name"=> "b", "required"=> true}]}
       endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "post", json), [])
       expect(endpoint.parameters).to eq("a, b, options = {}")
     end

     it "defines kwarg arguments when specified" do
       json = {"parameters"=> [{"name"=> "a", "required"=> true}, {"name"=> "b", "required"=> true}]}
       endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(OasParser::Path.new(nil, "meals/{meal_id}", {}), "post", json), [], parameterizer: OpenAPIClientGenerator::Endpoint::KwargsParameterizer)
       expect(endpoint.parameters).to eq("a:, b:, **options")
     end
  end

  context OpenAPIClientGenerator::API do
    it "determines the base documentation URL given a containing endpoint" do
      json = { "externalDocs" => { "url" => "http://example.com/meals/#cook-a-meal" }}
      endpoint = OpenAPIClientGenerator::Endpoint.new(OasParser::Endpoint.new(nil, nil, json), [])
      api = OpenAPIClientGenerator::API.new("path/to/meals/", endpoints: [endpoint])
      expect(api.documentation_url).to eq("http://example.com/meals/")
    end
  end
end
