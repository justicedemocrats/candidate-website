defmodule App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :totally mad website,
      version: "0.1.10",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {CandidateWebsite.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:cosmic, git: "https://github.com/justicedemocrats/cosmic_ex.git"},
      {:distillery, "~> 1.0.0"},
      {:short_maps, "~> 0.1.2"},
      {:browser, "~> 0.1.0"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"},
      {:quantum, "~> 2.0.0"},
      {:actionkit, git: "https://github.com/justicedemocrats/actionkit_ex.git"},
      {:httpotion, "~> 3.1.0"}
    ]
  end

  defp aliases do
    [
      "webpacker.setup": [
        "deps.get",
        "webpacker.frontend",
        "ecto.create",
        "run priv/repo/seeds.exs"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
