defmodule CandidateWebsite.RequirePlug do
  import Plug.Conn, only: [fetch_query_params: 1]
  import ShortMaps

  @required ~w(
    name district big_picture donate_url facebook twitter intro_statement
    intro_paragraph issues_header issues_paragraph why_support_header paid_for
    why_support_body action_shot quote primary_color highlight_color
    vote_registration_url vote_registration_icon vote_instructions_url
    vote_instructions_icon vote_location_url vote_location_icon header_background_color
    general_email press_email platform_header signup_prompt
  )

  @optional ~w(
    animation_fill_level target_html hero_text_color before_for_congress
    why_support_picture instagram google_analytics_id
  )

  @about_attrs ~w(
    occupation section_one quote_one quote_background_image section_two
    quote_two quote_side_image section_three headshot
  )

  def init(default), do: default

  def call(conn, _opts) do
    params = conn |> fetch_query_params() |> Map.get(:params)
    global_opts = GlobalOpts.get(conn, params)
    candidate = Keyword.get(global_opts, :candidate)

    %{"metadata" => metadata} = Cosmic.get("homepage-en", candidate)

    # endorsements =
    #   Cosmic.get_type("endorsements", candidate)
    #   |> Enum.map(fn %{"metadata" => ~m(organization_name organization_logo endorsement_text)} ->
    #        ~m(organization_name organization_logo endorsement_text)a
    #      end)

    %{"metadata" => about_metadata} = Cosmic.get("about-en", candidate)

    about_enabled = Enum.filter(@about_attrs, &Map.has_key?(about_metadata, &1)) |> length() == 9

    about =
      Enum.reduce(@about_attrs, %{}, fn key, acc ->
        Map.put(acc, String.to_atom(key), about_metadata[key])
      end)

    articles =
      Cosmic.get_type("articles", candidate)
      |> Enum.map(fn %{"metadata" => ~m(headline description thumbnail priority url)} ->
           priority = as_float(priority)
           headline = truncate(headline, 60)
           description = truncate(description, 140)
           ~m(headline description thumbnail priority url)a
         end)
      |> Enum.sort(&by_priority/2)

    issues =
      Cosmic.get_type("issues", candidate)
      |> Enum.map(fn %{"title" => title, "metadata" => ~m(header intro planks priority)} ->
           priority = as_float(priority)

           planks =
             planks |> Enum.map(fn ~m(statement description) -> ~m(statement description)a end)

           ~m(title header intro planks priority)a
         end)
      |> Enum.sort(&by_priority/2)

    event_slugs = Stash.get(:event_cache, "Calendar: #{metadata["name"]}") || []

    events =
      event_slugs
      |> Enum.map(fn slug -> Stash.get(:event_cache, slug) end)
      |> Enum.sort(&EventHelp.date_compare/2)
      |> Enum.map(&EventHelp.add_date_line/1)
      |> Enum.map(&EventHelp.add_candidate_attr/1)

    mobile = is_mobile?(conn)

    # Base, non homepage
    other_data = ~m(candidate about_enabled about issues mobile articles events)a

    # Add optional attrs
    optional_data =
      Enum.reduce(@optional, %{}, fn key, acc ->
        Map.put(acc, String.to_atom(key), metadata[key])
      end)

    # Add required attrs
    case Enum.filter(@required, &(not field_filled(metadata, &1))) do
      [] ->
        required_data =
          Enum.reduce(@required, ~m(candidate about issues mobile articles events)a, fn key, acc ->
            Map.put(acc, String.to_atom(key), metadata[key])
          end)

        data =
          other_data
          |> Map.merge(optional_data)
          |> Map.merge(required_data)

        conn
        |> Plug.Conn.assign(:data, data)
        |> Plug.Conn.assign(:enabled, %{about: about_enabled})

      non_empty ->
        Phoenix.Controller.text(
          conn,
          "Candidate #{candidate} is missing fields [#{Enum.join(non_empty, ", ")}] in homepage-en"
        )
    end
  end

  defp field_filled(map, field), do: Map.has_key?(map, field) and map[field] != ""

  defp is_mobile?(conn) do
    case List.keyfind(conn.req_headers, "user-agent", 0, "") do
      {_head, tail} -> Browser.mobile?(tail)
      _ -> false
    end
  end

  defp as_float(unknown) do
    {float, _} =
      case is_float(unknown) or is_integer(unknown) do
        true ->
          {unknown, true}

        false ->
          case unknown do
            "." <> _rest -> Float.parse("0" <> unknown)
            _ -> Float.parse(unknown)
          end
      end

    float
  end

  defp by_priority(%{priority: a}, %{priority: b}) do
    a <= b
  end

  defp truncate(string, length) do
    case String.slice(string, 0, length) do
      ^string -> string
      sliced -> sliced <> "..."
    end
  end
end
