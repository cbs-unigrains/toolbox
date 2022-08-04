defmodule ToolboxWeb.SerieLive.FormComponent do
  use ToolboxWeb, :live_component

  alias Toolbox.Chrono

  @impl true
  def update(%{serie: serie} = assigns, socket) do
    changeset = Chrono.change_serie(serie)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"serie" => serie_params}, socket) do
    changeset =
      socket.assigns.serie
      |> Chrono.change_serie(serie_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"serie" => serie_params}, socket) do
    save_serie(socket, socket.assigns.action, serie_params)
  end

  defp save_serie(socket, :edit, serie_params) do
    case Chrono.update_serie(socket.assigns.serie, serie_params) do
      {:ok, _serie} ->
        {:noreply,
         socket
         |> put_flash(:info, "Serie updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_serie(socket, :new, serie_params) do
    case Chrono.create_serie(serie_params) do
      {:ok, _serie} ->
        {:noreply,
         socket
         |> put_flash(:info, "Serie created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
