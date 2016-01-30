defmodule Fitbit.Activity do
  defstruct [:activity_type, :date, :value]

  def steps(user_token, start_date, end_date) do
    endpoint = "activities/steps/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["activities-steps"]
        |> parse_response(:steps)
      error ->
        error
    end
  end

  def floors(user_token, start_date, end_date) do
    endpoint = "activities/floors/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["activities-floors"]
        |> parse_response(:floors)
      error ->
        error
    end
  end

  defp parse_response(activities, type) do
    activities
    |> Enum.map(fn activity ->
        %Fitbit.Activity{
          activity_type: type,
          date: activity["dateTime"],
          value: activity["value"]
        }
      end)
  end
end
