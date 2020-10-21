
type FujiRequest
    headers::Dict{String,String}
    method::String
    params::Dict{String,String}
    query_params::Dict{String,String}
    resource::String
    splat::Array{String,1}

    FujiRequest(req::Request) = new(
        Dict{String,String}(req.headers), # headers
        req.method, # method
        Dict{String,String}(), # params
        Dict{String,String}(), # query params
        req.resource, # resource
        Array{String,1}() # splat
    )

    FujiRequest(req::Request, route::Route) = begin
        request = FujiRequest(req)

        named_param_regex = r":([A-z0-9\-_]+)"
        splat_param_regex = r"\*"
        component_string = "([A-z0-9\\-_]+)"

        # if there are named parameters in the endpoint
        if ismatch(named_param_regex, route.endpoint)
            params = Dict{String,String}()

            named_names = Array{String,1}()
            named_values = Array{String,1}()

            endpoint = route.endpoint

            while ismatch(named_param_regex, endpoint)
                m = match(named_param_regex, endpoint)
                push!(named_names, m.captures[1])

                endpoint = replace(route.endpoint, named_param_regex, m.captures[1], 1)
            end

            regex_endpoint = Regex(string("^", replace(route.endpoint, named_param_regex, component_string), "\$"))
            resource_match = match(regex_endpoint, split(request.resource, "?")[1])

            for capture in resource_match.captures
                push!(named_values, capture)
            end

            for i in 1:length(named_names)
                params[named_names[i]] = named_values[i]
            end

            request.params = params
        end

        # if there are splat parameters in the endpoint
        if contains(route.endpoint, "*")
            splat = Array{String,1}()

            regex_endpoint = Regex(string("^", replace(route.endpoint, splat_param_regex, component_string), "\$"))
            resource_match = match(regex_endpoint, split(request.resource, "?")[1])

            for capture in resource_match.captures
                push!(splat, capture)
            end

            request.splat = splat
        end

        # if there are query parameters in the endpoint
        if contains(request.resource, "?")
            query_params_string = split(request.resource, "?")[2]
            query_params_array = split(query_params_string, "&")
            query_params = Dict{String,String}()

            for query_param in query_params_array
                if contains(query_param, "=")
                    data = split(query_param, "=")
                    query_params[data[1]] = data[2]
                end
            end

            request.query_params = query_params
        end

        request
    end
end
