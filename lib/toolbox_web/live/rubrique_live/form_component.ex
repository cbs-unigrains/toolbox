defmodule ToolboxWeb.RubriqueLive.FormComponent do
  use ToolboxWeb, :live_component

  alias Toolbox.Chrono

  @impl true
  def update(%{rubrique: rubrique} = assigns, socket) do
    changeset = Chrono.change_rubrique(rubrique)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"rubrique" => rubrique_params}, socket) do
    changeset =
      socket.assigns.rubrique
      |> Chrono.change_rubrique(rubrique_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"rubrique" => rubrique_params}, socket) do
    save_rubrique(socket, socket.assigns.action, rubrique_params)
  end

  defp save_rubrique(socket, :edit, rubrique_params) do
    case Chrono.update_rubrique(socket.assigns.rubrique, rubrique_params) do
      {:ok, _rubrique} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rubrique updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_rubrique(socket, :new, rubrique_params) do
    case Chrono.create_rubrique(rubrique_params) do
      {:ok, _rubrique} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rubrique created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
