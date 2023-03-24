defmodule ParzivalWeb.LiveHelpers do
  @moduledoc false
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.faqs_index_path(@socket, :index)}>
        <.live_component
          module={ParzivalWeb.Backoffice.FaqsLive.FormComponent}
          id={@faqs.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.faqs_index_path(@socket, :index)}
          faqs: @faqs
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div id="modal-content" class="rounded-lg phx-modal-content fade-in-scale" phx-click-away={JS.dispatch("click", to: "#close")} phx-window-keydown={JS.dispatch("click", to: "#close")} phx-key="escape">
        <%= if @return_to do %>
          <%= live_patch to: @return_to, id: "close", class: "phx-modal-close", phx_click: hide_modal() do %>
            <svg xmlns="http://www.w3.org/2000/svg" class="flex-shrink-0 w-8 h-8 lg:mr-3 lg:w-6 lg:h-6" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          <% end %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>
            <svg xmlns="http://www.w3.org/2000/svg" class="flex-shrink-0 w-8 h-8 lg:mr-3 lg:w-6 lg:h-6" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </a>
        <% end %>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
