defmodule CandidateWebsite.EventCache do
  require Logger
  import ShortMaps

  def update do
    Logger.info("Updating event cache")

    # Fetch all events
    %{body: raw} = HTTPotion.get("https://map.justicedemocrats.com/api/events")
    all_events = Poison.decode!(raw)

    # Cache each by slug
    all_events |> Enum.each(&cache_by_name/1)

    # Cache all slugs as part of all
    Stash.set(:event_cache, "all_slugs", Enum.map(all_events, fn ~m(id) -> id end))

    # Filter each by calendar
    all_tags = Enum.flat_map(all_events, & &1["tags"])

    Enum.filter(all_tags, &String.contains?(&1, "Calendar:"))
    |> Enum.each(fn calendar ->
      calendar |> events_for_calendar(all_events) |> cache_calendar(calendar)
    end)

    Stash.persist(:event_cache, "event_cache")
    Logger.info("Updated event cache on #{Timex.now() |> DateTime.to_iso8601()}")

    all_events
  end

  def load_cached do
    Stash.load(:event_cache, "event_cache")
  end

  def fetch_or_load do
    try do
      update()
    rescue
      _e -> load_cached()
    end
  end

  defp cache_by_name(event) do
    Stash.set(:event_cache, event["id"], event)
  end

  def events_for_calendar(selected_calendar, events) do
    Enum.filter(events, fn ~m(tags) ->
      Enum.member?(tags, selected_calendar)
    end)
  end

  defp cache_calendar(events, calendar) do
    Stash.set(:event_cache, calendar, Enum.map(events, fn ~m(id) -> id end))
  end
end
