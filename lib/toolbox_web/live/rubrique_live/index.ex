defmodule ToolboxWeb.RubriqueLive.Index do
  use ToolboxWeb, :live_view

  alias Toolbox.Chrono
  alias Toolbox.Chrono.Rubrique

  @impl true
  def mount(%{"secteur_id" => secteur_id}, _session, socket) do
    secteur = Chrono.get_secteur!(secteur_id)

    {:ok,
     socket
     |> assign(:rubriques, list_rubriques(secteur_id))
     |> assign(:secteur, secteur)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Rubrique")
    |> assign(:rubrique, Chrono.get_rubrique!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rubrique")
    |> assign(:rubrique, %Rubrique{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rubriques")
    |> assign(:rubrique, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rubrique = Chrono.get_rubrique!(id)
    {:ok, _} = Chrono.delete_rubrique(rubrique)

    {:noreply, assign(socket, :rubriques, list_rubriques(rubrique.secteur_id))}
  end

  defp list_rubriques(secteur_id) do
    Chrono.list_rubriques(secteur_id)
  end
end
