defmodule ParzivalWeb.Components.Buttons do
  @moduledoc false
  use Phoenix.Component

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)

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
