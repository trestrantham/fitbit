defmodule Fitbit.Authentication do
  def refresh_token(refresh_token) do
    Fitbit.refresh_request(refresh_token)
  end
end
