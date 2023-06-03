defmodule ParzivalWeb.Components.WorkshopButton do
  @moduledoc false
  use ParzivalWeb, :component

  def workshop_button(assigns) do
    ~H"""
    <style>
      .ring {
        --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
        --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color);
        box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000);
      }
    </style>
    <a href={assigns.href} style={"transition: width 0.4s; top: #{assigns.top}rem; left: #{assigns.left}rem;"} class="flex overflow-hidden absolute z-50 items-center px-1 text-xl text-left rounded-full ring ring-white hover:px-2 w-[26px] h-[26px] group bg-secondary hover:w-[85px]">
      <span class="w-full text-center text-white group-hover:w-auto">+</span>
      <span style="transition: display 20s" class="hidden pl-1 text-sm text-white delay-100 group-hover:block">
        Register
      </span>
    </a>
    """
  end
end
