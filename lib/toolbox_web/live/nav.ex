defmodule ToolboxWeb.Nav do
  use Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:active_tab, :handle_params, &set_active_tab/3)}
  end

  defp set_active_tab(_params, _url, socket) do
    active_tab =
      case {socket.view, socket.assigns.live_action} do
        {ToolboxWeb.UnitLive.Index, _} ->
          "Chrono"

        {ToolboxWeb.SerieLive.Index, _} ->
          "Chrono"

        {ToolboxWeb.EfrontLive.Index, _} ->
          "eFront"

        {_, _} ->
          nil
      end

    {:cont, assign(socket, active_tab: active_tab)}
  end
end
