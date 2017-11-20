defmodule Cosmic.Migration do
  @campaign_attrs ~w(
    district launch_status brands small_picture website_blurb domain time_zone
    calling_script_link calling_prompt callable
  )

  def clone_object_type do
    %{body: %{"objects" => object_type}} = Cosmic.Api.get("object-type/candidates")

    metafields =
      object_type
      |> List.first()
      |> Map.get("metafields")
      |> Enum.map(fn field -> Map.drop(field, ["value"]) end)

    Cosmic.Api.post("add-object-type", body: %{
      write_key: "ifQygkWqctnCoWy3YnNZIFY9o3dHVDSB2QBeqwW3M7TW6eqk0Y",
      title: "Campaigns",
      metafields: metafields
    })
  end

  def clone_objects do
    Cosmic.get_type("candidates")
    |> Enum.map(&create_campaign/1)
  end

  def create_campaign(candidate) do
    campaign =
      candidate
      |> Map.put("type-slug", "campaigns")
      |> Map.take(~w())

    Cosmic.Api.post("add-object", campaign) |> IO.inspect()
  end

  def port_to(slug) do
    %{body: %{"object" => %{"metafields" => metafields}}} =
      Cosmic.Api.get("alexandria-ocasio-cortez")

    metafields =
      metafields
      |> Enum.map(fn field -> Map.drop(field, ["value"]) end)
      |> exclude(MapSet.new(@campaign_attrs))

    Cosmic.Api.post(
      "add-object-type",
      slug: slug,
      body: %{
        title: "Homepage",
        metafields: metafields
      }
    )
  end

  defp exclude(metafields, to_exclude) do
    Enum.reject(metafields, fn %{"key" => key} ->
      MapSet.member?(to_exclude, key)
    end)
  end

  def rich_text_why_support(slug) do
    %{body: %{"objects" => [%{"metafields" => metafields}]}} =
      Cosmic.Api.get("object-type/homepage", slug: slug)

    new_metafields =
      Enum.map(metafields, fn
        why_support_field = %{"key" => "why_support_body"} ->
          Map.put(why_support_field, "type", "html-textarea")

        other_field ->
          other_field
      end)

    IO.inspect(new_metafields)

    body = %{metafields: new_metafields, slug: "homepage"}
    Cosmic.Api.put("edit-object-type", body: body, slug: slug)
  end
end
