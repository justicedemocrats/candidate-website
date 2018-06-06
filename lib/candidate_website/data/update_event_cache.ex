defmodule CandidateWebsite.EventCache do
  require Logger
  import ShortMaps

  def update do
    Logger.info("Updating event cache")

    # Fetch all events
    %{body: raw} =
      HTTPotion.get(
        Application.get_env(:candidate_website, :osdi_api_event_url),
        headers: [
          "OSDI-API-Token": Application.get_env(:candidate_website, :osdi_api_token)
        ]
      )

    body = Poison.decode!(raw)

    events =
      Enum.filter(body["_embedded"]["osdi:events"], fn ~m(start_date) ->
        {:ok, dt, _} = DateTime.from_iso8601(start_date)
        Timex.before?(Timex.now(), dt)
      end)
      |> Enum.filter(fn ~m(status) -> status == "confirmed" end)

    Logger.info("#{length(events)} events in the future")

    # Cache each by slug
    Stash.set(:event_cache, "blob", events)
    :ok
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
end
