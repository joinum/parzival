defmodule ParzivalWeb.Components.Pagination do
  @moduledoc false
  use Phoenix.Component

  alias Plug.Conn.Query

  def pagination(assigns) do
    ~H"""
    <div class={@class}>
      <nav class="flex items-center justify-between w-full px-4 mb-5">
        <div class="flex flex-1 w-0 -mt-px">
          <%= if @meta.has_previous_page? do %>
            <%= live_patch to: build_query(@meta.previous_page, @params), class: "inline-flex items-center pt-4 pr-1 text-sm font-medium text-gray-500 hover:text-gray-700" do %>
              <svg class="w-5 h-5 mr-3 text-gray-400" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />
              </svg>
              Previous
            <% end %>
          <% end %>
        </div>
        <div class="hidden lg:flex lg:-mt-px">
          <%= if max(1, @meta.current_page - 2) != 1 do %>
            <%= live_patch("1", to: build_query(1, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700 ") %>

            <%= if @meta.current_page - 2 > 2 do %>
              <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500">
                ...
              </span>
            <% end %>
          <% end %>

          <%= for page <- max(1, @meta.current_page - 2)..max(min(@meta.total_pages, @meta.current_page + 2), 1) do %>
            <%= if @meta.current_page == page do %>
              <%= live_patch("#{page}", to: build_query(page, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-secondary") %>
            <% else %>
              <%= live_patch("#{page}", to: build_query(page, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
            <% end %>
          <% end %>

          <%= if min(@meta.total_pages, @meta.current_page + 2) != @meta.total_pages do %>
            <%= if @meta.current_page + 3 < @meta.total_pages do %>
              <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500">
                ...
              </span>
            <% end %>
            <%= live_patch("#{@meta.total_pages}", to: build_query(@meta.total_pages, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
          <% end %>
        </div>
        <div class="flex justify-end flex-1 w-0 -mt-px">
          <%= if @meta.has_next_page? do %>
            <%= live_patch to: build_query(@meta.next_page, @params), class: "inline-flex items-center pt-4 pl-1 text-sm font-medium text-gray-500 hover:text-gray-700" do %>
              Next
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ml-3 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            <% end %>
          <% end %>
        </div>
      </nav>
    </div>
    """
  end

  defp build_query(page, params) do
    query = Map.put(params, "page", page)

    "?#{Query.encode(query)}"
  end
end
