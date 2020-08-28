require "rubygems"
require "bundler"
require "readme/metrics"

require_relative "./application"
require_relative "./authentication"

readme_options = {
  api_key: "YOUR_API_KEY",
  development: true
}

use Rack::TokenAuth
use Readme::Metrics, readme_options do |env|
  current_user = env["CURRENT_USER"]

  if current_user.nil?
    {id: "guest", label: "Guest User", email: "guest@example.com"}
  else
    {id: current_user.id, label: current_user.name, email: current_user.email}
  end
end

run ReadmeSampleApp.new
