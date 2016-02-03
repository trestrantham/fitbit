defmodule Fitbit.Activity do
  alias Fitbit.Utils

  defstruct activity_type: nil, date: nil, value: nil

  @type t :: %__MODULE__{
    activity_type: atom, date: %Timex.DateTime{}, value: float
  }

  def steps(user_token, start_date, end_date) do
    endpoint = "activities/steps/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["activities-steps"]
        |> parse_activities(:steps)
      error ->
        error
    end
  end

  def floors(user_token, start_date, end_date) do
    endpoint = "activities/floors/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["activities-floors"]
        |> parse_activities(:floors)
      error ->
        error
    end
  end

  defp parse_activities(activities, type) do
    activities
    |> Enum.map(fn activity ->
        %Fitbit.Activity{
          activity_type: type,
          date: Utils.parse_date(activity["dateTime"]),
          value: activity["value"]
        }
      end)
  end
end
