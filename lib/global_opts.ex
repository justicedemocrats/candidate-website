defmodule GlobalOpts do
  @domains Application.get_env(:candidate_website, :domains)

  def get(_conn, %{"candidate" => candidate}) do
    [candidate: candidate]
  end

  def get(conn, _params) do
    [candidate: @domains[conn.host]]
  end
end
