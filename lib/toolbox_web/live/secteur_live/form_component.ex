defmodule ToolboxWeb.SecteurLive.FormComponent do
  use ToolboxWeb, :live_component

  alias Toolbox.Chrono

  @impl true
  def update(%{secteur: secteur} = assigns, socket) do
    changeset = Chrono.change_secteur(secteur)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"secteur" => secteur_params}, socket) do
    changeset =
      socket.assigns.secteur
      |> Chrono.change_secteur(secteur_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"secteur" => secteur_params}, socket) do
    save_secteur(socket, socket.assigns.action, secteur_params)
  end

  defp save_secteur(socket, :edit, secteur_params) do
    case Chrono.update_secteur(socket.assigns.secteur, secteur_params) do
      {:ok, _secteur} ->
        {:noreply,
         socket
         |> put_flash(:info, "Secteur updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_secteur(socket, :new, secteur_params) do
    case Chrono.create_secteur(secteur_params) do
      {:ok, _secteur} ->
        {:noreply,
         socket
         |> put_flash(:info, "Secteur created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
