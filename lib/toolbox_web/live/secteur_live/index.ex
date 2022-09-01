defmodule ToolboxWeb.SecteurLive.Index do
  use ToolboxWeb, :live_view

  alias Toolbox.Chrono
  alias Toolbox.Chrono.Secteur

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :secteurs, list_secteurs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Secteur")
    |> assign(:secteur, Chrono.get_secteur!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Secteur")
    |> assign(:secteur, %Secteur{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Secteurs")
    |> assign(:secteur, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    secteur = Chrono.get_secteur!(id)
    {:ok, _} = Chrono.delete_secteur(secteur)

    {:noreply, assign(socket, :secteurs, list_secteurs())}
  end

  defp list_secteurs do
    Chrono.list_secteurs()
  end
end
