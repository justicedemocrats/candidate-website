defmodule GlobalOpts do
  @domains Application.get_env(:candidate_website, :domains)

  def get(conn, %{"candidate" => candidate}) do
    [candidate: candidate]
  end

  def get(conn, _params) do
    [candidate: @doamins[conn.host]]
  end
end
