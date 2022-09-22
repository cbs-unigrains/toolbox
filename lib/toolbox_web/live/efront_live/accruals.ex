defmodule ToolboxWeb.EfrontLive.Accruals do
  use ToolboxWeb, :live_view

  alias Toolbox.Efront

  require Integer

  @impl true
  def mount(_params, _session, socket) do
    do_mount(socket)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Accruals")
  end

  def cumul_accruals(nil, _currency, _toggle_ids), do: 0

  def cumul_accruals(flows, currency, toggle_ids) do
    flows
    |> Enum.filter(fn f ->
      f.amount > 0 && f.currency == currency && f.glentry_id in toggle_ids
    end)
    |> Enum.reduce(0, fn f, acc -> f.amount + acc end)
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
    case Efront.export_accruals(glentries) do
      {:ok, %{transfer: transfer}} ->
        do_mount(socket)

      {:error, _name, _value, _changes_so_far} ->
        {:noreply, socket |> assign(:toggle_ids, [])}
    end


  end

  def stripped_row_class(idx) do
    if Integer.is_even(idx) do
      "bg-gray-50"
    else
      ""
    end
  end


  def do_mount(socket) do
    gl_entries = Efront.list_accruals()

    {:ok,
     socket
     |> assign(:toggle_ids, [])
     |> assign(:rows, gl_entries.rows)
     |> assign(:rows_with_index, gl_entries.rows_with_index)
     |> assign(:num_rows, gl_entries.num_rows)}
  end
end
