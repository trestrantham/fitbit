defmodule Fitbit.Utils do
  use Timex

  def parse_date(date) do
    case DateFormat.parse(date, "%Y-%m-%d", :strftime) do
      {:ok, date}        -> date
      {:error, _message} -> nil
    end
  end

  def parse_gender(gender) do
    gender = (gender || "")
    |> String.downcase

    case gender do
      "male"   -> :male
      "female" -> :female
      _        -> nil
    end
  end

  def parse_day(day) do
    day = (day || "")
    |> String.downcase

    case day do
      "sunday"    -> :sunday
      "monday"    -> :monday
      "tuesday"   -> :tuesday
      "wednesday" -> :wednesday
      "thursday"  -> :thursday
      "friday"    -> :friday
      "saturday"  -> :saturday
      _           -> nil
    end
  end
end
