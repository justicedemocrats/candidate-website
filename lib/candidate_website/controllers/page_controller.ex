defmodule CandidateWebsite.PageController do
  use CandidateWebsite, :controller
  plug CandidateWebsite.RequirePlug

  def index(conn, params) do
    %{name: name, district: district} = conn.assigns.data

    render conn, "index.html", [name: name, district: district]
  end
end
