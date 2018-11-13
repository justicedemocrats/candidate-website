defmodule MyCampaign do
  import ShortMaps

  def mycampaign_api_key(), do: Application.get_env(:candidate_website, :mycampaign_api_key)

  def find_or_create_person(~m(first_name last_name email phone zip)) do
    HTTPotion.post("https://api.securevan.com/v4/people/findOrCreate",
      body:
        Poison.encode!(
          %{
            "firstName" => first_name,
            "lastName" => last_name,
            "emails" => [
              %{
                "email" => email,
                "type" => "P",
                "isPreferred" => true,
                "isSubscribed" => true
              }
            ],
            "phones" => [
              %{
                "phoneNumber" => phone,
                "phoneType" => "C",
                "isPreferred" => true,
                "phoneOptInStatus" => "I"
              }
            ],
            "addresses" => [
              %{
                "zipOrPostalCode" => zip
              }
            ]
          }
          |> IO.inspect()
        ),
      headers: [
        Accept: "application/json",
        "Content-Type": "application/json"
      ],
      basic_auth: {"bpackerAPIUser", mycampaign_api_key()}
    )
    |> IO.inspect()
  end

  def find_or_create_on_email(~m(email zip)) do
    HTTPotion.post("https://api.securevan.com/v4/people/findOrCreate",
      body:
        Poison.encode!(
          %{
            "emails" => [
              %{
                "email" => email,
                "type" => "P",
                "isPreferred" => true,
                "isSubscribed" => true
              }
            ],
            "addresses" => [
              %{
                "zipOrPostalCode" => zip
              }
            ]
          }
          |> IO.inspect()
        ),
      headers: [
        Accept: "application/json",
        "Content-Type": "application/json"
      ],
      basic_auth: {"bpackerAPIUser", mycampaign_api_key()}
    )
    |> IO.inspect()
  end

  def add_activist_codes(van_id, activist_codes, volunteer \\ false) do
    responses =
      Enum.map(activist_codes |> IO.inspect(), fn code ->
        %{
          "activistCodeId" => mapping()[code],
          "action" => "Apply",
          "type" => "ActivistCode"
        }
      end)

    responses =
      if volunteer do
        Enum.concat(responses, [
          %{
            "surveyQuestionId" => 260_642,
            "type" => "SurveyResponse",
            "surveyResponseId" => 1_090_237
          }
        ])
      else
        responses
      end

    HTTPotion.post("https://api.securevan.com/v4/people/#{van_id}/canvassResponses",
      body:
        Poison.encode!(
          %{
            "responses" => responses,
            "canvassContext" => %{
              contactTypeId: 8
            }
          }
          |> IO.inspect()
        ),
      headers: [
        Accept: "application/json",
        "Content-Type": "application/json"
      ],
      basic_auth: {"bpackerAPIUser", mycampaign_api_key()}
    )
    |> IO.inspect()
  end

  def mapping,
    do: %{
      "make_calls" => 4_469_130,
      "host_a_fundraiser" => 4_469_129,
      "knock_doors" => 4_469_079,
      "send_texts" => 4_469_132,
      "website" => 4_470_298,
      "hacer_llamadas" => 4_469_130,
      "organizar_recaudacción_de_fondos" => 4_469_129,
      "tocar_puertas" => 4_469_079,
      "mandar_textos" => 4_469_132
    }
end
