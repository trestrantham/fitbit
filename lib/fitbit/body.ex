defmodule Fitbit.Body do
  alias Fitbit.Utils

  def weight(user_token, start_date, end_date) do
    endpoint = "body/weight/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["body-weight"]
        |> parse_samples(:weight)
      error ->
        error
    end
  end

  def bmi(user_token, start_date, end_date) do
    endpoint = "body/bmi/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["body-bmi"]
        |> parse_samples(:bmi)
      error ->
        error
    end
  end

  def fat(user_token, start_date, end_date) do
    endpoint = "body/fat/date/#{start_date}/#{end_date}"

    case Fitbit.user_request(:get, endpoint, user_token) do
      {:ok, body} ->
        body["body-fat"]
        |> parse_samples(:fat)
      error ->
        error
    end
  end

  defp parse_samples(samples, type) do
    samples
    |> Enum.map(fn sample ->
        %Fitbit.Sample{
          sample_type: type,
          date: Utils.parse_date(sample["dateTime"]),
          value: sample["value"]
        }
      end)
  end
end
