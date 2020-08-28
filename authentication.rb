module Rack
  class TokenAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      if authorized?(env)
        env = add_user_to_env(env)
      end

      @app.call(env)
    end

    private

    def authorized?(env)
      request = Rack::Request.new(env)
      auth_token = request.get_header("HTTP_AUTHORIZATION")

      !!auth_token && auth_token == "token"
    end

    def add_user_to_env(env)
      env.merge({"CURRENT_USER" => current_user})
    end

    def current_user
      CurrentUser.new(1, "Test Testerson", "testerson@example.com")
    end

    CurrentUser = Struct.new(:id, :name, :email) {
      def to_json
        {
          id: id,
          name: name,
          email: email
        }.to_json
      end
    }
  end
end
