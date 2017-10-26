defmodule CandidateWebsite.RequirePlug do
  import Plug.Conn, only: [fetch_query_params: 1]

  @required ~w(
    district big_picture donate_url facebook twitter intro_statement
    intro_paragraph issues_header issues_paragraph why_suppport_header
    why_support_body action_shot quote primary_color highlight_color
  )

  def init(default), do: default

  def call(conn, _opts) do
    params = conn |> fetch_query_params() |> Map.get(:params)
    global_opts = GlobalOpts.get(conn, params)
    candidate = Keyword.get(global_opts, :candidate)

    %{"title" => name, "metadata" => metadata} = Cosmic.get(candidate)

    IO.inspect(metadata)

    case Enum.filter(@required, &(not field_filled(metadata, &1))) do
      [] ->
        data =
          Enum.reduce(@required, %{name: name}, fn key, acc ->
            Map.put(acc, String.to_atom(key), metadata[key])
          end)

        Plug.Conn.assign(conn, :data, data)

      non_empty ->
        Phoenix.Controller.text(
          conn,
          "Candidate #{name} is missing fields [#{Enum.join(non_empty, ", ")}] in cosmic"
        )
    end
  end

  defp field_filled(map, field), do: Map.has_key?(map, field) and map[field] != ""
end
