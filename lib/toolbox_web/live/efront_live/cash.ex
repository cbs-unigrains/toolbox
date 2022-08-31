defmodule ToolboxWeb.EfrontLive.Cash do
  use ToolboxWeb, :live_view

  alias Toolbox.Efront

  require Integer

  @impl true
  def mount(_params, _session, socket) do
    gl_entries = list_accounting()

    {:ok,
     socket
     |> assign(:toggle_ids, [])
     |> assign(:rows_with_index, gl_entries.rows_with_index)
     |> assign(:rows, gl_entries.rows)
     |> assign(:num_rows, gl_entries.num_rows)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("toggle-all", %{"value" => "on"}, socket) do
    glentry_ids = socket.assigns.rows |> Enum.map(& &1.glentry_id)
    {:noreply, assign(socket, :toggle_ids, glentry_ids)}
  end

  @impl true
  def handle_event("toggle-all", %{}, socket) do
    {:noreply, assign(socket, :toggle_ids, [])}
  end

  @impl true
  def handle_event("toggle", %{"toggle-id" => id}, socket) do
    toggle_ids = socket.assigns.toggle_ids

    transaction = Enum.find(socket.assigns.rows, &(&1.glentry_id == id))

    ids =
      socket.assigns.rows
      |> Enum.filter(&(&1.transaction_id == transaction.transaction_id))
      |> Enum.map(& &1.glentry_id)

    toggle_ids =
      if id in toggle_ids do
        Enum.reject(toggle_ids, &(&1 in ids))
      else
        List.flatten(toggle_ids, ids)
      end

    {:noreply, assign(socket, :toggle_ids, toggle_ids)}
  end

  @impl true
  def handle_event("send-to", %{"glentry_to_send" => glentries}, socket) do
    IO.inspect(glentries)

    {:noreply, socket |> assign(:toggle_ids, [])}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cash")
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
      "bg-gray-50"
    else
      ""
    end
  end
end
