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


  @doc """
  Generate a announcement.
  """
  def announcement_fixture(attrs \\ %{}) do
    {:ok, announcement} =
      attrs
      |> Enum.into(%{
        text: "some text",
        title: "some title"
      })
      |> Parzival.Tools.create_announcement()

    announcement
  end
end
