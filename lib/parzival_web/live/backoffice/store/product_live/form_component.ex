defmodule ParzivalWeb.Backoffice.ProductLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Store

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Store.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Store.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Store.update_product(
           socket.assigns.product,
           product_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:success, "Product updated successfully!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Store.create_product(
           product_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp consume_image_data(socket, product) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      Store.update_product_image(product, %{
        "image" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, product}] ->
        {:ok, product}

      _errors ->
        {:ok, product}
    end
  end
end
