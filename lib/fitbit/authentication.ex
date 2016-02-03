defmodule Fitbit.Authentication do
  defstruct access_token: nil, expires_in: nil, refresh_token: nil,
            scope: nil, token_type: nil, user_id: nil

  @type t :: %__MODULE__{
    access_token: binary, expires_in: integer, refresh_token: binary,
    scope: binary, token_type: binary, user_id: binary
  }

  def refresh_token(refresh_token) do
    case Fitbit.refresh_request(refresh_token) do
      {:ok, body} ->
        body
        |> parse_authentication
      error ->
        error
    end
  end

  defp parse_authentication(authentication) do
    %Fitbit.Authentication{
      access_token: authentication["access_token"],
      expires_in: authentication["expires_in"],
      refresh_token: authentication["refresh_token"],
      scope: authentication["scope"],
      token_type: authentication["token_type"],
      user_id: authentication["user_id"]
    }
  end
end
