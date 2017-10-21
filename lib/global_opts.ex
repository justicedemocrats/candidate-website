defmodule GlobalOpts do
  def get(conn, %{"candidate" => candidate}) do
    [candidate: candidate]
  end
end
