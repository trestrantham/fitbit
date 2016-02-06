defmodule Fitbit.Sample do
  defstruct sample_type: nil, date: nil, value: nil

  @type t :: %__MODULE__{
    sample_type: atom, date: %DateTime{}, value: float
  }
end

defmodule Fitbit do
  @moduledoc """
  An HTTP client for Fitbit
  """

  use Application
  use HTTPoison.Base

  def start(_type, _args) do
    start
    Fitbit.Supervisor.start_link
  end

  @doc """
  Creates the URL for our endpoint.
  Args:
    * endpoint - part of the API we're hitting
  Returns string
  """
  def process_url(endpoint) do
    case endpoint do
      "oauth2/token" ->
        "https://api.fitbit.com/" <> endpoint
      _ ->
        "https://api.fitbit.com/" <> endpoint <> ".json"
    end
  end

  def process_request_body(body) do
    case body do
      {:form, _form_data} ->
        body
      _ ->
        Poison.encode! body
    end
  end

  def process_response_body(body) do
    Poison.decode! body
  end

  @doc """
  Set our request headers for every request.
  """
  def request_headers(auth_type, token) do
    headers = HashDict.new

    headers = case auth_type do
      :token ->
        headers |> Dict.put("Authorization", "Bearer #{token}")
      :basic_auth ->
        headers |> Dict.put("Authorization", "Basic #{basic_auth}")
    end

    headers
    |> Dict.put("User-Agent",    "Fitbit/v1 fitbit-elixir/0.0.1")
    |> Dict.put("Content-Type",  "application/x-www-form-urlencoded")
    |> Dict.to_list
  end

  def user_request(method, endpoint, token \\ "", body \\ "") do
    endpoint = "1/user/-/" <> endpoint

    api_request(method, endpoint, body, :token, token)
  end

  def refresh_request(refresh_token) do
    body = {
      :form,
      [
        {:grant_type, "refresh_token"},
        {:refresh_token, refresh_token}
      ]
    }

    api_request(:post, "oauth2/token", body, :basic_auth)
  end

  @doc """
  Boilerplate code to make requests.
  Args:
    * method - atom HTTP method
    * endpoint - string requested API endpoint
    * body - request body
    * auth_type - atom :token or :basic_auth
    * token - string user token
  Returns dict
  """
  def api_request(method, endpoint, body, auth_type, token \\ "") do
    headers = request_headers(auth_type, token)

    case request(method, endpoint, body, headers) do
      {:ok, response} ->
        (case response.body do
          %{"errors" => errors} ->
            error = List.first(errors)
            {:error, %{error: error["errorType"], message: error["message"]}}
          _ ->
            {:ok, response.body}
        end)
      {:error, reason} ->
        {:error, %{error: "bad_request", message: reason}}
    end
  end

  @doc """
  Gets the API key from :fitbit, :client_id application env or ENV
  Returns binary
  """
  def client_id do
    Application.get_env(:fitbit, :client_id) ||
      System.get_env("FITBIT_CLIENT_ID")
  end

  @doc """
  Gets the API key from :kraken, :fitbit, :client_secret application env or ENV
  Returns binary
  """
  def client_secret do
    Application.get_env(:fitbit, :client_secret) ||
      System.get_env("FITBIT_CLIENT_SECRET")
  end

  defp basic_auth do
    Base.encode64("#{client_id}:#{client_secret}")
  end
end
