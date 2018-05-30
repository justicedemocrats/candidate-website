defmodule CandidateWebsite.ShortenerController do
  import ShortMaps
  use CandidateWebsite, :controller

  def index(conn = %{request_path: path}, params) do
    # global_opts = GlobalOpts.get(conn, params)
    # candidate = Keyword.get(global_opts, :candidate)
    candidate = "alexandria-ocasio-cortez-staging"

    route =
      Cosmic.get_type("shortlinks", candidate)
      |> Enum.filter(fn %{"metadata" => object} -> match?(~m(from to), object) end)
      |> Enum.map(fn %{"metadata" => ~m(from to)} -> ~m(from to)a end)

    path = String.downcase(path)

    tuple_or_nil =
      route
      |> Enum.map(&prepare/1)
      |> Enum.filter(&matches(&1, path))
      |> List.first()

    destination =
      case tuple_or_nil do
        nil -> "homepage-en" |> Cosmic.get(candidate) |> get_in(["metadata", "domain"])
        {_, destination} -> destination
      end

    redirect(conn, external: https_prefix(destination))
  end

  defp matches({regex, _destination}, path) do
    Regex.run(regex, path) != nil
  end

  defp prepare(%{from: from_regex, to: to_url}) do
    {:ok, from} = from_regex |> String.downcase() |> Regex.compile()
    {from, to_url}
  end

  defp https_prefix(url = "http" <> _rest) do
    url
  end

  defp https_prefix(url) do
    "https://" <> url
  end
end
