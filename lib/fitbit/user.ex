defmodule Fitbit.User do
  def profile(user_token) do
    Fitbit.user_request(:get, "profile", user_token)
  end

  def badges(user_token) do
    Fitbit.user_request(:get, "badges", user_token)
  end
end
