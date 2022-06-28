defmodule ParzivalWeb.Components.Buttons do
  @moduledoc false
  use Phoenix.Component

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)

  def social_icons(assigns) do
    assigns =
      assigns
      |> assign_new(:twitter, fn -> nil end)
      |> assign_new(:github, fn -> nil end)
      |> assign_new(:linkedin, fn -> nil end)

    ~H"""
    <ul role="list" class="flex space-x-2">
      <%= if @twitter do %>
        <li>
          <a href={"https://twitter.com/#{@twitter}"} class="text-gray-400 hover:text-gray-500">
            <span class="sr-only">Twitter</span>
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 512 512" aria-hidden="true">
              <path d="M496 109.5a201.8 201.8 0 01-56.55 15.3 97.51 97.51 0 0043.33-53.6 197.74 197.74 0 01-62.56 23.5A99.14 99.14 0 00348.31 64c-54.42 0-98.46 43.4-98.46 96.9a93.21 93.21 0 002.54 22.1 280.7 280.7 0 01-203-101.3A95.69 95.69 0 0036 130.4c0 33.6 17.53 63.3 44 80.7A97.5 97.5 0 0135.22 199v1.2c0 47 34 86.1 79 95a100.76 100.76 0 01-25.94 3.4 94.38 94.38 0 01-18.51-1.8c12.51 38.5 48.92 66.5 92.05 67.3A199.59 199.59 0 0139.5 405.6a203 203 0 01-23.5-1.4A278.68 278.68 0 00166.74 448c181.36 0 280.44-147.7 280.44-275.8 0-4.2-.11-8.4-.31-12.5A198.48 198.48 0 00496 109.5z" />
            </svg>
          </a>
        </li>
      <% end %>
      <%= if @github do %>
        <li>
          <a href={"https://github.com/#{@github}"} class="text-gray-400 hover:text-gray-500">
            <span class="sr-only">GitHub</span>
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 512 512" aria-hidden="true">
              <path d="M256 32C132.3 32 32 134.9 32 261.7c0 101.5 64.2 187.5 153.2 217.9a17.56 17.56 0 003.8.4c8.3 0 11.5-6.1 11.5-11.4 0-5.5-.2-19.9-.3-39.1a102.4 102.4 0 01-22.6 2.7c-43.1 0-52.9-33.5-52.9-33.5-10.2-26.5-24.9-33.6-24.9-33.6-19.5-13.7-.1-14.1 1.4-14.1h.1c22.5 2 34.3 23.8 34.3 23.8 11.2 19.6 26.2 25.1 39.6 25.1a63 63 0 0025.6-6c2-14.8 7.8-24.9 14.2-30.7-49.7-5.8-102-25.5-102-113.5 0-25.1 8.7-45.6 23-61.6-2.3-5.8-10-29.2 2.2-60.8a18.64 18.64 0 015-.5c8.1 0 26.4 3.1 56.6 24.1a208.21 208.21 0 01112.2 0c30.2-21 48.5-24.1 56.6-24.1a18.64 18.64 0 015 .5c12.2 31.6 4.5 55 2.2 60.8 14.3 16.1 23 36.6 23 61.6 0 88.2-52.4 107.6-102.3 113.3 8 7.1 15.2 21.1 15.2 42.5 0 30.7-.3 55.5-.3 63 0 5.4 3.1 11.5 11.4 11.5a19.35 19.35 0 004-.4C415.9 449.2 480 363.1 480 261.7 480 134.9 379.7 32 256 32z" />
            </svg>
          </a>
        </li>
      <% end %>
      <%= if @linkedin do %>
        <li>
          <a href={"https://linkedin.com/in/#{@linkedin}"} class="text-gray-400 hover:text-gray-500">
            <span class="sr-only">LinkedIn</span>
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 512 512" aria-hidden="true">
              <path d="M444.17 32H70.28C49.85 32 32 46.7 32 66.89v374.72C32 461.91 49.85 480 70.28 480h373.78c20.54 0 35.94-18.21 35.94-38.39V66.89C480.12 46.7 464.6 32 444.17 32zm-273.3 373.43h-64.18V205.88h64.18zM141 175.54h-.46c-20.54 0-33.84-15.29-33.84-34.43 0-19.49 13.65-34.42 34.65-34.42s33.85 14.82 34.31 34.42c-.01 19.14-13.31 34.43-34.66 34.43zm264.43 229.89h-64.18V296.32c0-26.14-9.34-44-32.56-44-17.74 0-28.24 12-32.91 23.69-1.75 4.2-2.22 9.92-2.22 15.76v113.66h-64.18V205.88h64.18v27.77c9.34-13.3 23.93-32.44 57.88-32.44 42.13 0 74 27.77 74 87.64z" />
            </svg>
          </a>
        </li>
      <% end %>
    </ul>
    """
  end

  def radio_button(assigns) do
    assigns = assign_new(assigns, :color, fn -> :gray end)

    ~H"""
    <label class={"w-9 relative p-0.5 rounded-full flex items-center justify-center cursor-pointer focus:outline-none #{@active && "ring ring-offset-1 #{get_ring_color(@color)}"}"}>
      <%= render_slot(@inner_block) %>
      <p class="sr-only"><%= @color %></p>
      <span aria-hidden="true" class={"h-8 w-8 #{get_bg_color(@color)} border border-black border-opacity-10 rounded-full"}></span>
    </label>
    """
  end

  defp get_bg_color(nil), do: "bg-neutral-500"

  defp get_bg_color(color) when is_atom(color) do
    color
    |> Atom.to_string()
    |> get_bg_color()
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp get_bg_color(color) when color in @colors do
    case color do
      "gray" -> "bg-gray-500"
      "red" -> "bg-red-500"
      "orange" -> "bg-orange-500"
      "amber" -> "bg-amber-500"
      "yellow" -> "bg-yellow-500"
      "lime" -> "bg-lime-500"
      "green" -> "bg-green-500"
      "emerald" -> "bg-emerald-500"
      "teal" -> "bg-teal-500"
      "cyan" -> "bg-cyan-500"
      "sky" -> "bg-sky-500"
      "blue" -> "bg-blue-500"
      "indigo" -> "bg-indigo-500"
      "violet" -> "bg-violet-500"
      "purple" -> "bg-purple-500"
      "fuchsia" -> "bg-fuchsia-500"
      "pink" -> "bg-pink-500"
      "rose" -> "bg-rose-500"
    end
  end

  defp get_ring_color(nil), do: "ring-neutral-500"

  defp get_ring_color(color) when is_atom(color) do
    color
    |> Atom.to_string()
    |> get_ring_color()
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp get_ring_color(color) when color in @colors do
    case color do
      "gray" -> "ring-gray-500"
      "red" -> "ring-red-500"
      "orange" -> "ring-orange-500"
      "amber" -> "ring-amber-500"
      "yellow" -> "ring-yellow-500"
      "lime" -> "ring-lime-500"
      "green" -> "ring-green-500"
      "emerald" -> "ring-emerald-500"
      "teal" -> "ring-teal-500"
      "cyan" -> "ring-cyan-500"
      "sky" -> "ring-sky-500"
      "blue" -> "ring-blue-500"
      "indigo" -> "ring-indigo-500"
      "violet" -> "ring-violet-500"
      "purple" -> "ring-purple-500"
      "fuchsia" -> "ring-fuchsia-500"
      "pink" -> "ring-pink-500"
      "rose" -> "ring-rose-500"
    end
  end
end
