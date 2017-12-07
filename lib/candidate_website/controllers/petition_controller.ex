defmodule CandidateWebsite.PetitionController do
  import ShortMaps
  use CandidateWebsite, :controller
  plug(CandidateWebsite.RequirePlug)

  def get(conn, ~m(slug draft)) do
    assigns = ~m(candidate)a = Map.get(conn.assigns, :data)
    petition = Cosmic.get(slug, candidate) |> extract_data()
    render(conn, "petition.html", Map.merge(petition, assigns) |> Enum.into(slug: slug))
  end

  def get(conn, ~m(slug)) do
    assigns = ~m(candidate)a = Map.get(conn.assigns, :data)

    case Cosmic.get(slug, candidate) |> extract_data() |> IO.inspect() do
      petition = %{visibility: "Published"} ->
        render(conn, "petition.html", Map.merge(petition, assigns) |> Enum.into(slug: slug))

      _petition ->
        redirect(conn, external: assigns.domain)
    end
  end

  def post(conn, params = ~m(slug)) do
    assigns = ~m(candidate)a = Map.get(conn.assigns, :data)
    petition = Cosmic.get(slug, candidate) |> extract_data()

    [given_name, family_name] =
      case String.split(params["name"], " ") do
        [first_only] -> [first_only, ""]
        n_list -> [List.first(n_list), List.last(n_list)]
      end

    email_address = params["email"]
    postal_addresses = [%{postal_code: params["zip"]}]

    person =
      Map.merge(
        ~m(email_address postal_addresses given_name family_name)a,
        if(
          Map.has_key?(params, "phone") and params["phone"] != "",
          do: %{phone_number: params["phone"]},
          else: %{}
        )
      )

    Osdi.PersonSignup.main(%{
      person: person,
      add_tags: ["Action: Signed Petition: #{Keyword.get(assigns, :name)}: #{petition.title}"]
    })

    render(
      conn,
      "petition.html",
      Map.merge(petition, assigns) |> Enum.into(signed: true, slug: slug)
    )
  end

  defp extract_data(petition) do
    %{"content" => content, "metadata" => ~m(
        title sign_button_text background_image post_sign_text tweet_template
        visibility share_image redirect_url
      )} = petition

    ~m(content title sign_button_text background_image post_sign_text
       tweet_template visibility share_image redirect_url)a
  end
end
