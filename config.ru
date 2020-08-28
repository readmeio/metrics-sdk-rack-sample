require "rubygems"
require "bundler"
require "readme/metrics"

require_relative "./application"

readme_options = {
  api_key: "YOUR_API_KEY",
  development: true
}

use Readme::Metrics, readme_options do |env|
  {id: "gues", label: "Rack Sample App", email: "user@example.com"}
end

run ReadmeSampleApp.new

