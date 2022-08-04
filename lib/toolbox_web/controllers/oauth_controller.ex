defmodule Toolbox.OauthController do
  @moduledoc """
  Récupère les informations de connexion provenant de Microsoft

  %Ueberauth.Auth.Info{
    birthday: nil,
    description: nil,
    email: "CBERNARDES@unigrains.fr",
    first_name: "Claudio",
    image: nil,
    last_name: "BERNARDES",
    location: nil,
    name: "BERNARDES Claudio",
    nickname: nil,
    phone: nil,
    urls: %{}
  }
  """
  use ToolboxWeb, :controller
  plug Ueberauth

  alias Toolbox.Accounts

  @rand_pass_length 32
  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, %{
        "provider" => "microsoft"
      }) do
    IO.inspect(conn)
    user_params = %{email: user_info.email, password: random_password(), display_name: user_info.name, image: user_info.image}

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        ToolboxWeb.UserAuth.log_in_user(conn, user)

      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
