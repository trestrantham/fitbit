defmodule Fitbit.User do
  use Timex

  alias Fitbit.Utils

  defstruct [
    :about_me, :avatar, :avatar150, :city, :country, :date_of_birth,
    :display_name, :distance_unit, :encoded_id, :foods_locale, :full_name,
    :gender, :glucose_unit, :height, :height_unit, :locale, :member_since,
    :nickname, :offset_from_utc_millis, :start_day_of_week, :state,
    :stride_length_running, :stride_length_walking, :timezone, :water_unit,
    :weight, :weight_unit
  ]

  @type t :: %__MODULE__{
    about_me: binary, avatar: binary, avatar150: binary, city: binary,
    country: binary, date_of_birth: %DateTime{}, display_name: binary,
    distance_unit: binary, encoded_id: binary, foods_locale: binary,
    full_name: binary, gender: atom, glucose_unit: binary, height: float,
    height_unit: binary, locale: binary, member_since: %DateTime{},
    nickname: binary, offset_from_utc_millis: integer, start_day_of_week: atom,
    state: binary, stride_length_running: float, stride_length_walking: float,
    timezone: binary, water_unit: binary, weight: float, weight_unit: binary
  }

  def profile(user_token) do
    case Fitbit.user_request(:get, "profile", user_token) do
      {:ok, body} ->
        body["user"]
        |> parse_user
      error ->
        error
    end
  end

  def badges(user_token) do
    Fitbit.user_request(:get, "badges", user_token)
  end

  defp parse_user(user) do
    %Fitbit.User{
      about_me: user["aboutMe"],
      avatar: user["avatar"],
      avatar150: user["avatar150"],
      city: user["city"],
      country: user["country"],
      date_of_birth: Utils.parse_date(user["dateOfBirth"]),
      display_name: user["displayName"],
      distance_unit: user["distanceUnit"],
      encoded_id: user["encodedId"],
      foods_locale: user["foodsLocale"],
      full_name: user["fullName"],
      gender: Utils.parse_gender(user["gender"]),
      glucose_unit: user["glucoseUnit"],
      height: user["height"],
      height_unit: user["heightUnit"],
      locale: user["locale"],
      member_since: Utils.parse_date(user["memberSince"]),
      nickname: user["nickname"],
      offset_from_utc_millis: user["offsetFromUTCMillis"],
      start_day_of_week: Utils.parse_day(user["startDayOfWeek"]),
      state: user["state"],
      stride_length_running: user["strideLengthRunning"],
      stride_length_walking: user["strideLengthWalking"],
      timezone: user["timezone"],
      water_unit: user["waterUnit"],
      weight: user["weight"],
      weight_unit: user["weightUnit"]
    }
  end
end
