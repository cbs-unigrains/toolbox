defmodule ToolboxWeb.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Toolbox.Accounts
  alias Toolbox.Accounts.User
  alias ToolboxWeb.Router.Helpers, as: Routes

  require Logger

  @doc """
  The default on_mount use the user_token to retrieve
    - the current_user
    - if the user has a spotify account
  """
  def on_mount(:default, _params, %{"user_token" => user_token}, socket) do
    case Accounts.get_user_by_session_token(user_token) do
      %User{} = user ->
        {:cont, assign(socket, :current_user, user)}

      nil ->
        socket =
          socket
          |> put_flash(:error, "You must log in to access this page.")
          |> redirect(to: Routes.user_session_path(socket, :new))

        {:halt, socket}
    end
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :current_user, nil)}
  end
end
