defmodule ToolboxWeb.EfrontLive.Cash do
  use ToolboxWeb, :live_view

  alias Toolbox.Efront

  require Integer

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
    |> assign(:page_title, "Listing Cash")
    |> assign(:serie, nil)
    |> assign(view_to_show: :cash)
  end

  defp list_accounting do
    Efront.list_cash()
  end

  def cumul_cash(flows, currency) do
    flows
    |> Enum.filter(fn f -> f.amount > 0 && f.currency == currency end)
    |> Enum.reduce(0, fn f, acc -> f.amount + acc end)
  end

  def stripped_row_class(idx) do
    if Integer.is_even(idx) do
      "bg-gray-100"
    else
      ""
    end
  end
end
