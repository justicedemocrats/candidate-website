defmodule CandidateWebsite.PageView do
  use CandidateWebsite, :view

  @states File.read!("./lib/candidate_website/views/states.json") |> Poison.decode!()

  def fb_share, do: "/images/facebook.svg"
  def twitter_share, do: "/images/twitter.svg"

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
      _dnum -> @states[abbrev] <> " " <> num
    end
  end

  def state(district) do
    [abbrev, _num] = String.split(district, "-")
    @states[abbrev]
  end

  def csrf_token() do
    Plug.CSRFProtection.get_csrf_token()
  end

  def th_district(district) do
    [abbrev, num] = String.split(district, "-")

    if num == "SN" do
      "#{@states[abbrev]} Senate"
    else
      {last_num, _} = num |> String.last() |> Integer.parse()

      cond do
        last_num == 1 -> "#{num}st District of #{@states[abbrev]}"
        last_num == 2 -> "#{num}nd District of #{@states[abbrev]}"
        true -> "#{num}st district of #{@states[abbrev]}"
      end
    end
  end
end
