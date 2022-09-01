defmodule ToolboxWeb.SerieLive.Series do
  use ToolboxWeb, :live_view

  alias Toolbox.Chrono
  alias Toolbox.Chrono.Serie

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :series, list_series())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Serie")
    |> assign(:serie, Chrono.get_serie!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Serie")
    |> assign(:serie, %Serie{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Series")
    |> assign(:serie, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    serie = Chrono.get_serie!(id)
    {:ok, _} = Chrono.delete_serie(serie)

    {:noreply, assign(socket, :series, list_series())}
  end

  defp list_series do
    Chrono.list_series()
  end
end
