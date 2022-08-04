defmodule ToolboxWeb.UnitLive.Index do
  use ToolboxWeb, :live_view

  alias Toolbox.Chrono
  alias Toolbox.Chrono.Unit

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :unit_collection, list_unit())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Unit")
    |> assign(:unit, Chrono.get_unit!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Unit")
    |> assign(:unit, %Unit{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Unit")
    |> assign(:unit, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    unit = Chrono.get_unit!(id)
    {:ok, _} = Chrono.delete_unit(unit)

    {:noreply, assign(socket, :unit_collection, list_unit())}
  end

  defp list_unit do
    Chrono.list_unit()
  end
end
