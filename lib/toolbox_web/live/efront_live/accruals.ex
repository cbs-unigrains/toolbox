defmodule ToolboxWeb.EfrontLive.Accruals do
  use ToolboxWeb, :live_view

  alias Toolbox.Efront

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :series, list_accounting())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Accruals")
    |> assign(:serie, nil)
    |> assign(view_to_show: :accruals)
  end

  defp list_accounting do
    {:ok, result} = Efront.list_accruals()
    result
  end
end
