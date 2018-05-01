defmodule CandidateWebsite.PageController do
  import ShortMaps
  use CandidateWebsite, :controller
  plug(CandidateWebsite.RequirePlug)

  def index(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "index.html", Enum.into(assigns, []))
  end

  def about(conn, _params) do
    %{enabled: %{about: about_enabled}, data: assigns} = Map.take(conn.assigns, [:data, :enabled])

    if about_enabled do
      render(conn, "about.html", Enum.into(assigns, []))
    else
      redirect(conn, to: "/#about")
    end
  end

  def platform(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "platform.html", Enum.into(assigns, []))
  end

  def signup(conn, params) do
    data = %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)
    ~m(email zip name) = params

    extra = if Map.has_key?(params, "phone"), do: %{phone: params["phone"]}, else: %{}

    [given_name, family_name] =
      case String.split(name, " ") do
        [g, f] -> [g, f]
        [g] -> [g, nil]
        more -> [List.first(more), List.last(more)]
      end

    case data do
      %{action_network_api_key: action_network_api_key} when not is_nil(action_network_api_key) ->
        HTTPotion.post(
          "https://actionnetwork.org/api/v2/people",
          headers: [
            Accept: "application/hal+json",
            "Content-Type": "application/json",
            "OSDI-API-Token": action_network_api_key
          ],
          body:
            Poison.encode!(%{
              "person" => %{
                "given_name" => given_name,
                "family_name" => family_name,
                "email_addresses" => [
                  %{"address" => email}
                ],
                "postal_addresses" => [
                  %{
                    "postal_code" => zip,
                    "primary" => true
                  }
                ],
                "custom_fields" => %{
                  "Mobile Phone" => params["phone"]
                }
              },
              "add_tags" => ["website-signup"]
            })
        )

      _ ->
        Ak.Signup.process_signup(candidate_name, Map.merge(~m(email zip name), extra))
    end

    redirect(conn, external: donate_url)
  end

  def volunteer(conn, params) do
    cand_data = %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)

    data =
      Map.keys(params)
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(~w(email name phone zip _csrf_token)))
      |> MapSet.to_list()
      |> Enum.reduce(params, fn checkbox, acc ->
        if params[checkbox] do
          Map.put(acc, "action_" <> checkbox, true)
        else
          Map.put(acc, "action_" <> checkbox, false)
        end
      end)
      |> IO.inspect()

    extra = if params["ref"], do: %{source: params["ref"]}, else: %{}

    matcher = fn ~m(title) ->
      String.contains?(title, "Volunteer") and String.contains?(title, candidate_name)
    end

    [given_name, family_name] =
      case String.split(params["name"], " ") do
        [g, f] -> [g, f]
        [g] -> [g, nil]
        more -> [List.first(more), List.last(more)]
      end

    case cand_data do
      %{action_network_api_key: action_network_api_key} when not is_nil(action_network_api_key) ->
        HTTPotion.post(
          "https://actionnetwork.org/api/v2/people",
          headers: [
            Accept: "application/hal+json",
            "Content-Type": "application/json",
            "OSDI-API-Token": action_network_api_key
          ],
          body:
            Poison.encode!(%{
              "person" => %{
                "given_name" => given_name,
                "family_name" => family_name,
                "email_addresses" => [
                  %{"address" => params["email"]}
                ],
                "custom_fields" => %{
                  "Mobile Phone" => params["phone"]
                },
                "postal_addresses" => [
                  %{
                    "postal_code" => params["zip"],
                    "primary" => true
                  }
                ]
              },
              "add_tags" =>
                Enum.concat(
                  ["website-volunteer"],
                  Enum.filter(
                    ~w(call_voters join_team attend_event host_event),
                    &Map.has_key?(params, &1)
                  )
                  |> Enum.map(&"volunteer-interest:#{&1}")
                )
            })
        )

      _ ->
        Ak.Signup.process_signup(matcher, Map.merge(data, extra))
    end

    destination =
      case candidate_name do
        "Robb" <> _ -> "https://now.brandnewcongress.org/act"
        "Marc Whit" <> _ -> "https://now.brandnewcongress.org/act"
        _ -> "https://now.justicedemocrats.com/act"
      end

    redirect(conn, external: destination)
  end
end
