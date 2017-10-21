defmodule CandidateWebsite.PageController do
  use CandidateWebsite, :controller

  def index(conn, params) do
    global_opts = GlobalOpts.get(conn, params)
    candidate = Keyword.get(global_opts, :candidate)

    %{"title" => name, "metadata" => %{
      "district" => district
    }} = Cosmic.get(candidate)

    render conn, "index.html", [name: name, district: district]
  end
end
