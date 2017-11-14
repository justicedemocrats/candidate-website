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
    %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)
    ~m(email zip) = params

    email_address = email
    postal_addresses = [%{postal_code: zip}]

    ref = Map.get(params, "ref", nil)

    tags = ["Action: Joined Website: #{candidate_name}"]

    tags =
      if ref do
        Enum.concat(tags, ["Action: Joined Website: #{candidate_name}: #{ref}"])
      else
        tags
      end

    Osdi.PersonSignup.main(%{
      person: ~m(email_address postal_addresses)a,
      add_tags: tags
    })

    redirect(conn, external: donate_url)
  end

  def volunteer(conn, params) do
    %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)

    data =
      Enum.reduce(~w(call_voters join_team attend_event host_event), params, fn checkbox, acc ->
        if params[checkbox] do
          Map.put(acc, checkbox, true)
        else
          Map.put(acc, checkbox, false)
        end
      end)

    ref = Map.get(params, "ref", nil)

    ~m(email zip call_voters join_team attend_event host_event) = data

    email_address = email
    postal_addresses = [%{postal_code: zip}]

    tags =
      [
        {call_voters, "Call Voters"},
        {join_team, "Join Team"},
        {attend_event, "Attend Event"},
        {host_event, "Host Event"}
      ]
      |> Enum.filter(fn {pred, _} -> pred end)
      |> Enum.map(fn {_, str} -> "Action: Volunteer Desire: #{candidate_name}: #{str}" end)
      |> Enum.concat(["Action: Joined As Volunteer: #{candidate_name}"])

    tags =
      if ref do
        Enum.concat(tags, ["Action: Joined as Volunteer: #{candidate_name}: #{ref}"])
      else
        tags
      end

    Osdi.PersonSignup.main(%{
      person: ~m(email_address postal_addresses)a,
      add_tags: tags
    })

    redirect(conn, external: donate_url)
  end
end
