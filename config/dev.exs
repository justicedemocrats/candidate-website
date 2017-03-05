use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :webpacker, Webpacker.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  cache_static_lookup: false,
  watchers: [
    node: ["node_modules/.bin/webpack-dev-server", "--inline", "--colors", "--hot", "--stdin", "--host", "localhost", "--port", "8080", "--public", "localhost:8080",
    cd: Path.expand("../assets", __DIR__)
  ]]

# Watch static and templates for browser reloading.
config :webpacker, Webpacker.Web.Endpoint,
  live_reload: [
    patterns: [
      #~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      #~r{priv/gettext/.*(po)$},
      ~r{web/web/views/.*(ex)$},
      ~r{web/web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :webpacker, Webpacker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "webpacker_dev",
  hostname: "localhost",
  pool_size: 10
