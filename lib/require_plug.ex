defmodule CandidateWebsite.RequirePlug do
  import Plug.Conn, only: [fetch_query_params: 1]
  import ShortMaps

  @required ~w(
    name district big_picture donate_url facebook twitter intro_statement
    intro_paragraph issues_header issues_paragraph why_support_header paid_for
    why_support_body why_support_picture action_shot quote primary_color highlight_color
    vote_registration_url vote_registration_icon vote_instructions_url
    vote_instructions_icon vote_location_url vote_location_icon header_background_color
    district_image
  )

  def init(default), do: default

  def call(conn, _opts) do
    params = conn |> fetch_query_params() |> Map.get(:params)
    global_opts = GlobalOpts.get(conn, params)
    candidate = Keyword.get(global_opts, :candidate)

    %{"metadata" => metadata} = Cosmic.get("homepage-en", candidate)

    endorsements =
      Cosmic.get_type("endorsements", candidate)
      |> Enum.map(fn %{"metadata" => ~m(organization_name organization_logo endorsement_text)} ->
           ~m(organization_name organization_logo endorsement_text)a
         end)

    %{"content" => about_content, "metadata" => %{"image" => about_image}} = Cosmic.get("about-en", candidate)
    about = ~m(about_content about_image)

    case Enum.filter(@required, &(not field_filled(metadata, &1))) do
      [] ->
        data =
          Enum.reduce(@required, ~m(endorsements about)a, fn key, acc ->
            Map.put(acc, String.to_atom(key), metadata[key])
          end)

        Plug.Conn.assign(conn, :data, data)

      non_empty ->
        Phoenix.Controller.text(
          conn,
          "Candidate #{candidate} is missing fields [#{Enum.join(non_empty, ", ")}] in cosmic"
        )
    end
  end

  defp field_filled(map, field), do: Map.has_key?(map, field) and map[field] != ""
end
