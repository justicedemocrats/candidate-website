defmodule CandidateWebsite.LayoutView do
  use CandidateWebsite, :view

  @script_src Application.get_env(
                :candidate_website,
                :script_src,
                ~s(<script src="http://localhost:8080/js/app.js"></script>)
              )
  @css_src Application.get_env(:candidate_website, :css_src, "")

  def js_script_tag, do: @script_src

  def css_link_tag, do: @css_src
end
