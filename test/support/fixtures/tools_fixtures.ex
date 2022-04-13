defmodule Parzival.ToolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parzival.Tools` context.
  """

  @doc """
  Generate a faqs.
  """
  def faqs_fixture(attrs \\ %{}) do
    {:ok, faqs} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        question: "some question"
      })
      |> Parzival.Tools.create_faqs()

    faqs
  end
end
