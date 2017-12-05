use Mix.Config

# General application configuration
config :candidate_website, ecto_repos: [Osdi.Repo]

# Configures the endpoint
config :candidate_website, CandidateWebsite.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bfsqn9AcIMywYeFfFrwwtpRis6Jda9AQdRrc20qyXzQlB4oBV/FA+Isy4jDAB77n",
  render_errors: [view: CandidateWebsite.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CandidateWebsite.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Cipher
config :cipher,
  keyphrase: "testiekeyphraseforcipher",
  ivphrase: "testieivphraseforcipher",
  magic_token: "magictoken"

# Cosmic
config :cosmic,
  slugs: [
    "alexandria-ocasio-cortez",
    "alison-hartson",
    "ben-packer",
    "adrienne-bell",
    "anthony-clark",
    "chardo-richardson",
    "cori-bush",
    "letitia-plummer",
    "paula-jean-swearengin",
    "sarah-smith",
    "david-gill",
    "robb-ryerse",
    "marc-whitmire",
    "rick-trevino"
  ]

# Domains
config :candidate_website,
  domains: %{
    "alisonhartson.com" => "alison-hartson",
    "www.alisonhartson.com" => "alison-hartson",
    "robb2018.com" => "robb-ryerse",
    "www.robb2018.com" => "robb-ryerse",
    "votesarahsmith.com" => "sarah-smith",
    "www.votesarahsmith.com" => "sarah-smith",
    "ocasio2018.com" => "alexandria-ocasio-cortez",
    "www.ocasio2018.com" => "alexandria-ocasio-cortez",
    "bell2018.com" => "adrienne-bell",
    "www.bell2018.com" => "adrienne-bell",
    "whitmire2018.com" => "marc-whitmire",
    "www.whitmire2018.com" => "marc-whitmire",
    "anthonyclark2018.com" => "anthony-clark",
    "www.anthonyclark2018.com" => "anthony-clark",
    "paulajean2018.com" => "paula-jean-swearengin",
    "www.paulajean2018.com" => "paula-jean-swearengin",
    "votecoribush.com" => "cori-bush",
    "www.votecoribush.com" => "cori-bush"
    "www.chardo2018.com" => "chardo-richardson",
    "chardo2018.com" => "chardo-richardson"
  }

jobs =
  [
    {"*/2 * * * *", {CandidateWebsite.EventCache, :update, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
