defmodule CandidateWebsite.PageController do
  import ShortMaps
  use CandidateWebsite, :controller
  plug(CandidateWebsite.RequirePlug)

  def index(conn, _params) do
    if Map.has_key?(conn.cookies, "returning_visitor") do
      assigns = Map.get(conn.assigns, :data)
      render(conn, "index.html", Enum.into(assigns, []))
    else
      conn
      |> put_resp_cookie("returning_visitor", "true", max_age: 15 * 86400)
      |> redirect(to: "/splash")
    end
  end

  def about(conn, _params) do
    %{enabled: %{about: about_enabled}, data: assigns} = Map.take(conn.assigns, [:data, :enabled])

    # if about_enabled do
    render(conn, "about.html", Enum.into(assigns, []))
    # else
    #   redirect(conn, to: "/#about")
    # end
  end

  def platform(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "platform.html", Enum.into(assigns, []))
  end

  def press(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "news.html", Enum.into(assigns, []))
  end

  def endorsements(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "endorsements.html", Enum.into(assigns, []))
  end

  def splash(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "splash.html", Enum.into(assigns, []))
  end

  def green_new_deal(conn, _params) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "green_new_deal.html", Enum.into(assigns, []))
  end

  def green_new_deal_temp(conn, _) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "green_new_deal_temp.html", assigns)
  end

  def signup(conn, params) do
    data = %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)
    ~m(email zip) = params

    extra = if Map.has_key?(params, "phone"), do: %{phone: params["phone"]}, else: %{}
    name = if Map.has_key?(params, "name"), do: params["name"], else: ""

    [first_name, last_name] =
      case String.split(name, " ") do
        [g, f] -> [g, f]
        [g] -> [g, nil]
        more -> [List.first(more), List.last(more)]
      end

    resp =
      MyCampaign.find_or_create_person(
        ~m(first_name last_name email zip)
        |> Map.merge(%{"phone" => params["phone"]})
      )

    ~m(vanId) = Poison.decode!(resp.body)
    MyCampaign.add_activist_codes(vanId, ["website"])

    redirect(conn, external: donate_url)
  end

  def volunteer(conn, params) do
    cand_data = %{name: candidate_name, donate_url: donate_url} = Map.get(conn.assigns, :data)

    activist_codes =
      Map.keys(params)
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(~w(email name phone zip _csrf_token candidate)))
      |> MapSet.to_list()
      |> Enum.filter(fn checkbox -> Map.has_key?(params, checkbox) end)

    extra = if params["ref"], do: %{source: params["ref"]}, else: %{}

    matcher = fn ~m(title) ->
      String.contains?(title, "Volunteer") and String.contains?(title, candidate_name)
    end

    [first_name, last_name] =
      case String.split(params["name"], " ") do
        [g, f] -> [g, f]
        [g] -> [g, nil]
        more -> [List.first(more), List.last(more)]
      end

    resp = MyCampaign.find_or_create_person(~m(first_name last_name) |> Map.merge(params))
    ~m(vanId) = Poison.decode!(resp.body)
    MyCampaign.add_activist_codes(vanId, activist_codes |> Enum.concat(["website"]), true)

    destination =
      case candidate_name do
        "Robb" <> _ -> "https://now.brandnewcongress.org/act"
        "Marc Whit" <> _ -> "https://now.brandnewcongress.org/act"
        _ -> "https://www.ocasio2018.com/events"
      end

    redirect(conn, external: destination)
  end

  def info(conn, _) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "info.html", assigns)
  end

  def get_volunteer(conn, _) do
    assigns = Map.get(conn.assigns, :data)
    render(conn, "volunteer.html", assigns)
  end

  def nice_tag(tag) do
    tag
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def splash_form(conn, params) do
    activist_codes =
      Map.keys(params)
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(~w(email phone _csrf_token candidate)))
      |> MapSet.to_list()

    resp = MyCampaign.find_or_create_on_email(params)
    ~m(vanId) = Poison.decode!(resp.body)
    MyCampaign.add_activist_codes(vanId, activist_codes |> Enum.concat(["website"]), false)

    redirect(conn, to: "/")
  end
end
