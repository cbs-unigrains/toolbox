defmodule ToolboxWeb.SecteurLive.Show do
  use ToolboxWeb, :live_view

  alias Toolbox.Chrono

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:secteur, Chrono.get_secteur!(id))}
  end

  defp page_title(:show), do: "Show Secteur"
  defp page_title(:edit), do: "Edit Secteur"
end
