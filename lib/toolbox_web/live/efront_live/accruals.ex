defmodule ToolboxWeb.EfrontLive.Accruals do
  use ToolboxWeb, :live_view

  alias Toolbox.Efront

  @impl true
  def mount(_params, _session, socket) do
    gl_entries = list_accounting()

    {:ok,
     socket
     |> assign(:toggle_ids, [])
     |> assign(:rows, gl_entries.rows || [])
     |> assign(:num_rows, gl_entries.num_rows)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Accruals")
  end

  defp list_accounting do
    {:ok, result} = Efront.list_accruals()
    result
  end

  def cumul_accruals(nil, _currency), do: 0

  def cumul_accruals(flows, currency) do
    flows
    |> Enum.filter(fn f -> f.amount > 0 && f.currency == currency end)
    |> Enum.reduce(0, fn f, acc -> f.amount + acc end)
  end
end
