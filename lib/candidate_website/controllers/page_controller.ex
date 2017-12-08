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
    ~m(email zip name) = params

    extra = if Map.has_key?(params, "phone"), do: %{phone: params["phone"]}, else: %{}
    Ak.Signup.process_signup(candidate_name, Map.merge(~m(email zip name), extra))

    redirect(conn, external: donate_url)
  end

  def volunteer(conn, params) do
    %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)

    data =
      Enum.reduce(~w(call_voters join_team attend_event host_event), params, fn checkbox, acc ->
        if params[checkbox] do
          Map.put(acc, "action_" <> checkbox, true)
        else
          Map.put(acc, "action_" <> checkbox, false)
        end
      end)

    extra = if params["ref"], do: %{source: params["ref"]}, else: %{}

    matcher = fn ~m(title) ->
      String.contains?(title, "Volunteer") and String.contains?(title, candidate_name)
    end

    Ak.Signup.process_signup(matcher, Map.merge(data, extra))

    destination = case candidate_name do
      "Robb" <> _ -> "https://now.brandnewcongress.org/act"
      "Marc Whit" <> _ -> "https://now.brandnewcongress.org/act"
      _ -> "https://now.justicedemocrats.com/act"
    end

    redirect(conn, external: destination)
  end
end
