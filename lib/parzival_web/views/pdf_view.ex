defmodule ParzivalWeb.PdfView do
  use ParzivalWeb, :view

  require Integer

  def render("cv.pdf", assigns) do
    # `render("document.html", assigns)` is generated at compile time from the .eex template.
    # Here we explicitly render it to a string and generate a PDF out of that.
    render_to_string(__MODULE__, "cv.html", assigns)
    |> PdfGenerator.generate_binary!(
      delete_temporary: true,
      page_size: "A4",
      filename: "attendee_#{Ecto.UUID.generate()}",
      shell_params: [
        "--disable-smart-shrinking",
        "--margin-top",
        "0",
        "--margin-left",
        "0",
        "--margin-right",
        "0",
        "--margin-bottom",
        "0"
      ]
    )
  end
end
