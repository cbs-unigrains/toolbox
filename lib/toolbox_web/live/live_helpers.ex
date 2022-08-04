defmodule ToolboxWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.unit_index_path(@socket, :index)}>
        <.live_component
          module={ToolboxWeb.UnitLive.FormComponent}
          id={@unit.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.unit_index_path(@socket, :index)}
          unit: @unit
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div
      id="modal"
      class="z-50 fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity fade-in"
      phx-remove={hide_modal()}
    >
      <div class="fixed z-10 inset-0 overflow-y-auto">
        <div class="flex items-end sm:items-center justify-center min-h-full p-4 text-center sm:p-0">
          <div class="relative bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:max-w-lg sm:w-full">
            <div
              id="modal-content"
              class="fade-in-scale"
              phx-click-away={JS.dispatch("click", to: "#close")}
              phx-window-keydown={JS.dispatch("click", to: "#close")}
              phx-key="escape"
            >
              <%= if @return_to do %>
                <.link patch={@return_to} id="close" class="phx-modal-close" phx-click={hide_modal()}>
                  <.icon name={:x} />
                </.link>
              <% else %>
                <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>
                  <.icon name={:x} />
                </a>
              <% end %>

              <%= render_slot(@inner_block) %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  ################################
  #
  # FLYOUT MENU
  #
  def flyout_menu(assigns) do
    assigns =
      assigns
      |> assign_new(:active, fn -> false end)
      |> assign_new(:id, fn -> "flyout_#{Enum.random(1..100_000_000)}" end)

    ~H"""
    <div>
      <!-- Item active: "text-gray-900", Item inactive: "text-gray-500" -->
      <button
        type="button"
        class={
          " #{if @active, do: "bg-gray-900"} text-white px-3 py-2 rounded-md text-sm font-medium group inline-flex items-center "
        }
        aria-expanded="false"
        phx-click={toggle_flyout_menu("##{@id}")}
        phx-click-away={hide_flyout_menu("##{@id}")}
      >
        <span><%= @label %></span>
        <!--
        Item active: "text-gray-600", Item inactive: "text-gray-400"
        -->
        <.icon name={:chevron_down} class="text-gray-400 ml-1 h-5 w-5 group-hover:text-gray-100" />
      </button>

      <div
        id={@id}
        class="absolute z-10 top-full inset-x-0 transform shadow-lg bg-white"
        style="display: none"
      >
        <div class="max-w-7xl mx-auto grid gap-y-6 px-4 py-6 sm:grid-cols-2 sm:gap-8 sm:px-6 sm:py-8 lg:grid-cols-4 lg:px-8 lg:py-12 xl:py-16">
          <%= render_slot(@inner_block) %>
        </div>
        <div class="bg-gray-50">
          <div class="max-w-7xl mx-auto space-y-6 px-4 py-5 sm:flex sm:space-y-0 sm:space-x-10 sm:px-6 lg:px-8">
            <div class="flow-root">
              <a
                href="#"
                class="-m-3 p-3 flex items-center rounded-md text-base font-medium text-gray-900 hover:bg-gray-100"
              >
                <.icon name={:play} outlined class="flex-shrink-0 h-6 w-6 text-gray-400" />
                <span class="ml-3">Documentation</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def flyout_menu_element(assigns) do
    ~H"""
    <.link href={@patch} class="-m-3 p-3 flex flex-col justify-between rounded-lg hover:bg-gray-50">
      <div class="flex md:h-full lg:flex-col">
        <div class="flex-shrink-0">
          <span class="inline-flex items-center justify-center h-10 w-10 rounded-md bg-indigo-500 text-white sm:h-12 sm:w-12">
            <.icon name={@icon} outlined />
          </span>
        </div>
        <div class="ml-4 md:flex-1 md:flex md:flex-col md:justify-between lg:ml-0 lg:mt-4">
          <div>
            <p class="text-base font-medium text-gray-900"><%= @title %></p>
            <p class="mt-1 text-sm text-gray-500"><%= @subtitle %></p>
          </div>
          <p class="mt-2 text-sm font-medium text-indigo-600 lg:mt-4">
            <%= @link_label %> <span aria-hidden="true">&rarr;</span>
          </p>
        </div>
      </div>
    </.link>
    """
  end

  @doc """
     Shows a flyout menu.
  """
  def toggle_flyout_menu(to) do
    JS.toggle(
      to: to,
      in:
        {"transition ease-out duration-200", "opacity-0 -translate-y-1",
         "opacity-100 translate-y-0"},
      out:
        {"transition ease-in duration-150", "opacity-100 translate-y-0",
         "opacity-0 -translate-y-1"}
    )
  end

  @doc """
  Hide a dropdown.
  """
  def hide_flyout_menu(%JS{} = js, to) do
    js
    |> JS.hide(
      to: to,
      transition:
        {"transition ease-in duration-150", "opacity-100 translate-y-0",
         "opacity-0 -translate-y-1"}
    )
  end

  def hide_flyout_menu(to), do: hide_flyout_menu(%JS{}, to)

  #################################
  #
  #  DROPDOWN
  #
  #

  def dropdown(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "dropdown_#{Enum.random(1..100_000_000)}" end)

    ~H"""
    <div class="relative inline-block text-left">
      <div>
        <button
          type="button"
          class="bg-gray-800 flex text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white"
          phx-click={show_dropdown("##{@id}")}
          phx-click-away={hide_dropdown("##{@id}")}
        >
          <%= render_slot(@trigger) %>
        </button>
      </div>
      <div
        id={@id}
        class="origin-top-right right-0 absolute mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none"
        role="menu"
        tabindex="-1"
        style="display: none"
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
     Shows a dropdown.

  """
  def show_dropdown(to) do
    JS.show(
      to: to,
      transition:
        {"transition ease-out duration-100", "transform opacity-0 scale-95",
         "transform opacity-100 scale-100"}
    )
  end

  @doc """
  Hide a dropdown.
  """
  def hide_dropdown(%JS{} = js, to) do
    js
    |> JS.hide(
      to: to,
      transition:
        {"transition ease-in duration-75", "transform opacity-100 scale-100",
         "transform opacity-0 scale-95"}
    )
  end

  def hide_dropdown(to), do: hide_dropdown(%JS{}, to)

  @doc """
     Helper for heroicons icon.

  """
  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:outlined, fn -> false end)
      |> assign_new(:class, fn -> "w-6 h-6" end)
      |> assign_new(:"aria-hidden", fn -> !Map.has_key?(assigns, :"aria-label") end)

    ~H"""
    <%= if @outlined do %>
      <%= apply(Heroicons.Outline, @name, [assigns_to_attributes(assigns, [:outlined, :name])]) %>
    <% else %>
      <%= apply(Heroicons.Solid, @name, [assigns_to_attributes(assigns, [:outlined, :name])]) %>
    <% end %>
    """
  end

  #################################
  #
  # LINK
  #
  #

  def link(%{navigate: to} = assigns) do
    opts = assigns_to_attributes(assigns) |> Keyword.put(:to, to)
    assigns = assign(assigns, :opts, opts)

    ~H"""
    <%= live_redirect @opts do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def link(%{patch: to} = assigns) do
    opts = assigns |> assigns_to_attributes() |> Keyword.put(:to, to)
    assigns = assign(assigns, :opts, opts)

    ~H"""
    <%= live_patch @opts do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def link(%{} = assigns) do
    opts = assigns |> assigns_to_attributes() |> Keyword.put(:to, assigns[:href] || "#")
    assigns = assign(assigns, :opts, opts)

    ~H"""
    <%= Phoenix.HTML.Link.link @opts do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  #################################
  #
  # FORM
  #
  #

  import Phoenix.HTML.Form

  def form_label(assigns) do
    opts =
      assigns
      |> assign_new(:class, fn -> "block text-sm font-medium text-gray-700" end)
      |> assigns_to_attributes([:form, :field, :for])

    assigns = assign(assigns, :opts, opts)

    if Map.has_key?(assigns, :for) do
      ~H"""
      <label for={@for} {@opts}>
        <%= render_slot(@inner_block) %>
      </label>
      """
    else
      ~H"""
      <%= label @form, @field, @opts do %>
        <%= render_slot(@inner_block) %>
      <% end %>
      """
    end
  end

  @text_css "shadow-sm focus:ring-violet-500 focus:border-violet-500 block w-full sm:text-sm border-gray-300 rounded-md"
  def text_input(assigns) do
    opts =
      assigns
      |> assign_new(:class, fn -> @text_css end)
      |> assigns_to_attributes([:form, :field])

    assigns = assign(assigns, :opts, opts)

    ~H"""
    <%= text_input(@form, @field, @opts) %>
    """
  end

  @select_css "max-w-lg block focus:ring-indigo-500 focus:border-indigo-500 w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
  def select(assigns) do
    opts =
      assigns
      |> assigns_to_attributes([:form, :field, :options])
      |> Keyword.put_new(:class, @select_css)

    assigns = assign(assigns, :opts, opts)

    ~H"""
    <%= select(@form, @field, @options, @opts) %>
    """
  end

  def hidden_input(assigns) do
    ~H"""
    <%= hidden_input(@form, @field) %>
    """
  end
end
