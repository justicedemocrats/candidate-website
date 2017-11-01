defmodule CandidateWebsite.PageView do
  use CandidateWebsite, :view

  @states File.read!("./lib/candidate_website/views/states.json") |> Poison.decode!()

  def fb_share, do: "https://www.google.com"
  def twitter_share, do: "https://www.google.com"

  def congress_or_senate(district),
    do: district
        |> String.split("-")
        |> List.last()
        |> congress_or_senate_from_bit()

  def congress_or_senate_from_bit("SN"), do: "Senate"
  def congress_or_senate_from_bit(_), do: "Congress"

  def human_district(district) do
    [abbrev, num] = String.split(district, "-")

    case num do
      "SN" -> @states[abbrev]
      dnum -> @states[abbrev] <> " " <> num
    end
  end
end
