defmodule Parzival.ToolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parzival.Tools` context.
  """

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        question: "some question"
      })
      |> Parzival.Tools.create_faq()

    faq
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
