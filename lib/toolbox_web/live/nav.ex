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
          {"Chrono", nil}

        {ToolboxWeb.SerieLive.Index, _} ->
          {"Chrono",
           "Permet de gérer les secteur, rubrique et détail de classification des séries."}

        {ToolboxWeb.SecteurLive.Index, _} ->
          {"Chrono", "Permet de créer, modifier les secteurs"}

        {ToolboxWeb.EfrontLive.Cash, _} ->
          {"Flux Cash",
           "Permet de sélectionner les écritures CASH à envoyer vers la comptabilité."}

        {ToolboxWeb.EfrontLive.Accruals, _} ->
          {"ICNEs", "Permet de sélectionner les ICNEs à envoyer vers la comptabilité."}

        {_, _} ->
          {nil, nil}
      end

    {:cont,
     socket
     |> assign(active_tab: elem(active_tab, 0))
     |> assign(active_tab_desc: elem(active_tab, 1))}
  end
end
