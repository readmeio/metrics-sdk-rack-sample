require 'rack'
require 'json'

class ReadmeSampleApp
  def call(env)
    request = Rack::Request.new(env)
    route_info = get_route_info(request)

    puts "Route info: #{route_info}"

    case route_info
    in path: "/", action: :index
      root_route
    in path: "cars", action: :index
      car_list
    in path: "cars", action: :show
      show_car(route_info[:id])
    in path: "cars", action: :destroy
      destroy_car(route_info[:id])
    in path: "cars", action: :create
      body = request.body.read
      create_car(JSON.parse(body))
    else
      not_found
    end

  rescue JSON::ParserError => error
    unprocessable_entity(error.message)
  rescue
    bad_request
  end

  private

  def get_route_info(request)
    fragments = request.path.split("/").reject(&:empty?)
    id, action = find_id_and_action(fragments[1], request)
    {action: action, path: fragments[0] || "/" , id: id}
  end

  def find_id_and_action(fragment, request)

    case fragment
    when "new"
      [nil, :new]
    when nil
      action = request_method_to_action(request.request_method)
      [nil, action]
    else
      action = request.delete? ? :destroy : :show
      [fragment, action]
    end
  end

  def request_method_to_action(method)
    case request.request_method
    when "GET"
      :index
    when "DELETE"
      :destroy
    else
      :create
    end
  end

  def root_route
    success_response("Welcome", "text/plain")
  end

  def car_list
    success_response(cars.to_json, "application/json")
  end

  def show_car(id)
    return bad_request("Missing car id in request") if id.nil?
    found_car = cars.find { |car| car[:id].to_s == id }

    if found_car.nil?
      not_found("Car with id #{id} not found")
    else
      success_response(found_car.to_json, "application/json")
    end
  end

  def create_car(params)
    next_id = cars.map { |car| car[:id] }.max + 1
    new_car = {
      id: next_id,
      make: params["make"],
      model: params["model"],
      year: params["year"]
    }

    unless new_car.values.any?(&:nil?)
      cars.push(new_car)
      success_response(new_car.to_json, "application/json")
    else
      unprocessable_entity("You must provide all values to add a new car")
    end
  end

  def destroy_car(id)
    return bad_request("Missing car id in request") if id.nil?
    cars.reject! { |car| car[:id].to_s == id }
    success_response("Car with id #{id} deleted", "text/plain")
  end

  def success_response(body, content_type)
    status = 200
    headers = {
      "Content-Length" => body.bytesize.to_s,
      "Content-Type" => content_type
    }

    [status, headers, [body]]
  end

  def unprocessable_entity(message = "Couldn't process the request")
    return [422, { "Content-Type" => "text/plain" }, [message]]
  end

  def not_found(message = "Route not found")
    return [404, { "Content-Type" => "text/plain" }, [message]]
  end

  def bad_request(message = "Bad request")
    return [400, { "Content-Type" => "text/plain" }, [message]]
  end

  def cars
    @cars ||= [
      { id: 1, make: "Volkswagen", model: "Golf", year: 2021 },
      { id: 2, make: "Volkswagen", model: "GTI", year: 2021 },
      { id: 3, make: "Volkswagen", model: "Golf R", year: 2020 },
      { id: 4, make: "Audi", model: "RS3", year: 2020 },
      { id: 5, make: "Audi", model: "TT", year: 2020 },
      { id: 6, make: "Audi", model: "R8", year: 2020 },
    ]
  end
end


