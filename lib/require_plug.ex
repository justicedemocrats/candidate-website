defmodule CandidateWebsite.RequirePlug do
  import Plug.Conn, only: [fetch_query_params: 1]
  import ShortMaps

  @domains Application.get_env(:candidate_website, :domains)

  @required ~w(
    name district big_picture donate_url facebook twitter intro_statement
    intro_paragraph issues_header issues_paragraph why_support_header paid_for
    why_support_body action_shot quote primary_color highlight_color
    vote_registration_url vote_registration_icon vote_instructions_url
    vote_instructions_icon vote_location_url vote_location_icon header_background_color
    general_email press_email platform_header platform_chunk_header signup_prompt
    campaign_video early_life experience moving_forward
  )

  @optional ~w(
    animation_fill_level target_html hero_text_color before_for_congress
    why_support_picture instagram google_analytics_id linkedin hide_lets
    action_network_api_key google_tag_manager_id google_optimize_id volunteer_options
    master privacy_policy join_button_color state_logo
  )

  @about_attrs ~w(
    occupation section_one quote_one quote_background_image section_two
    quote_two quote_side_image section_three headshot
  )

  def init(default), do: default

  def call(conn, _opts) do
    params = conn |> fetch_query_params() |> Map.get(:params)
    # global_opts = GlobalOpts.get(conn, params)
    # candidate = Keyword.get(global_opts, :candidate)

    IO.inspect(Plug.Conn.get_req_header(conn, "accept-language"))

    lang =
      case Map.get(params, "lang", conn.cookies["lang"]) do
        nil -> if prefers_spanish?(conn), do: "es", else: "en"
        l -> l
      end

    candidate =
      case lang do
        "en" -> "alexandria-ocasio-cortez-staging"
        l -> "alexandria-ocasio-cortez-#{l}"
      end

    %{"metadata" => metadata} = Cosmic.get("homepage-en", candidate)

    endorsements =
      try do
        Cosmic.get_type("endorsements", candidate)
        |> Enum.map(fn %{
                         "metadata" =>
                           ~m(organization_name organization_logo endorsement_text endorsement_url)
                       } ->
          organization_slug =
            organization_name |> String.downcase() |> String.replace(~r/\s+/, "_")

          ~m(organization_name organization_slug organization_logo endorsement_text endorsement_url)a
        end)
      rescue
        _e -> []
      end

    %{"metadata" => about_metadata} = Cosmic.get("about-en", candidate)

    about_enabled = Enum.filter(@about_attrs, &Map.has_key?(about_metadata, &1)) |> length() == 9

    about =
      Enum.reduce(@about_attrs, %{}, fn key, acc ->
        Map.put(acc, String.to_atom(key), about_metadata[key])
      end)

    offices =
      Cosmic.get_type("offices", candidate)
      |> Enum.map(fn %{
                       "title" => title,
                       "slug" => slug,
                       "metadata" =>
                         metadata =
                           ~m(priority address_line_1 address_line_2 google_maps_api_key)
                     } ->
        priority = as_float(priority)

        map_url =
          "https://www.google.com/maps/search/?api=1&query=#{address_line_1}, #{address_line_2}"

        map_image_url = metadata["google_mags_image"][~s(imgix_url)] || "https://maps.googleapis.com/maps/api/staticmap?markers=color:0x3C2D82|#{address_line_1}, #{address_line_2}&zoom=15&size=400x400&key=#{google_maps_api_key}"

        ~m(title slug priority address_line_1 address_line_2 map_url map_image_url)a
      end)
      |> Enum.sort(&by_priority/2)

    # offices =
    #   Cosmic.get_type("offices", candidate)
    #   |> Enum.map(fn %{
    #     "title" => title,
    #     "slug" => slug,
    #     "metadata" => metadata = ~m(priority address_line_1 address_line_2 google_maps_api_key)
    #     } ->
    #     priority = as_float(priority)
    #     [address_line_1, address_line_2, google_maps_api_key] = [metadata["address_line_1"], metadata["address_line_2"], metadata["google_maps_api_key"]]
    #     map_url = "https://www.google.com/maps/search/?api=1&query=#{address_line_1}, #{address_line_2}"
    #     map_image_url = "https://maps.googleapis.com/maps/api/staticmap?markers=color:0x3C2D82|#{address_line_1}, #{address_line_2}&zoom=15&size=400x400&key=#{google_maps_api_key}"
    #     ~m(title slug address_line_1 address_line_2 google_maps_api_key map_url map_image_url)a
    #   end)
    #   |> Enum.sort(&by_priority/2)

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
      |> Enum.map(fn %{
                       "title" => title,
                       "slug" => slug,
                       "metadata" => metadata = ~m(header intro priority show_on_homepage)
                     } ->
        priority = as_float(priority)
        full = metadata["full_content"] || intro
        icon = metadata["icon"] || %{}
        show_on_homepage = show_on_homepage == "Show"
        ~m(title slug header intro priority full show_on_homepage icon)a
      end)
      |> Enum.sort(&by_priority/2)

    event_slugs = Stash.get(:event_cache, "Calendar: #{metadata["name"]}") || []

    events = EventHelp.events_for(metadata["name"])

    mobile = is_mobile?(conn)

    # Base, non homepage
    domain = get_candidate_domain(candidate)

    other_data =
      ~m(candidate domain about_enabled about issues mobile articles events offices endorsements lang)a

    # Add optional attrs
    optional_data =
      Enum.reduce(@optional, %{}, fn key, acc ->
        Map.put(acc, String.to_atom(key), metadata[key])
      end)

    # Add required attrs
    case Enum.filter(@required, &(not field_filled(metadata, &1))) do
      [] ->
        required_data =
          Enum.reduce(
            @required,
            ~m(candidate about issues offices mobile articles events)a,
            fn key, acc ->
              Map.put(acc, String.to_atom(key), metadata[key])
            end
          )

        data =
          other_data
          |> Map.merge(optional_data)
          |> Map.merge(required_data)

        Gettext.put_locale(CandidateWebsite.Gettext, lang)

        conn
        |> Plug.Conn.assign(:data, data)
        |> Plug.Conn.assign(:enabled, %{about: about_enabled})
        |> Plug.Conn.put_resp_cookie("lang", lang)

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

  defp get_candidate_domain(candidate) do
    match =
      @domains
      |> Enum.map(fn {domain, cand_slug} -> {cand_slug, domain} end)
      |> Enum.into(%{})
      |> Map.get(candidate)

    case match do
      nil -> nil
      _ -> "https://" <> match
    end
  end

  def prefers_spanish?(conn) do
    case Plug.Conn.get_req_header(conn, "accept-language") do
      [value | _] ->
        value
        |> String.split(";")
        |> Enum.filter(fn lang -> String.contains?(lang, "es") end)
        |> List.first()

      nil ->
        false
    end
  end
end
