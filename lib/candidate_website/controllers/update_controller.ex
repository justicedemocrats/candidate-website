defmodule CandidateWebsite.UpdateController do
  use CandidateWebsite, :controller
  require Logger

  def get_cosmic(conn, _params) do
    Cosmic.update()

    json(conn, %{
      "unnecessary" =>
        "Ben implemented webhooks! No need to visit hit this link any more, but an update just happened just in case. If it's not updating, contact Ben. Thanks!"
    })
  end

  def post_cosmic(conn, params) do
    Cosmic.update()

    json(conn, %{
      "unnecessary" =>
        "Ben implemented webhooks! No need to visit hit this link any more, but an update just happened just in case. If it's not updating, contact Ben. Thanks!"
    })
  end

  def get_events(conn, _) do
    json(conn, EventHelp.events_for("Alexandria Ocasio-Cortez"))
  end
end
