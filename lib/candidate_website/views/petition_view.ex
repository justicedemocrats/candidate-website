defmodule CandidateWebsite.PetitionView do
  use CandidateWebsite, :view

  def csrf_token() do
    Plug.CSRFProtection.get_csrf_token()
  end
end
