defmodule ParzivalWeb.ViewUtils do
  @moduledoc """
  Utility functions to be used on all views.
  """

  def extract_initials(nil), do: ""

  def extract_initials(name) do
    initials = name |> String.upcase() |> String.split(" ") |> Enum.map(&String.slice(&1, 0, 1))

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> List.last(initials)
    end
  end

  def extract_first_last_name(nil), do: ""

  def extract_first_last_name(name) do
    initials = name |> String.split(" ")

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> " " <> List.last(initials)
    end
  end

end
