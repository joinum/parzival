defmodule Parzival.Store do
  @moduledoc """
  The Store context.
  """
  use Parzival.Context

  alias Ecto.Multi

  alias Parzival.Accounts.User
  alias Parzival.Store.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(params \\ %{})

  def list_products(opts) when is_list(opts) do
    Product
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_products(flop) do
    Flop.validate_and_run(Product, flop, for: Product)
  end

  def list_products(%{} = flop, opts) when is_list(opts) do
    Product
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(
        %Product{} = product,
        attrs,
        after_save \\ &{:ok, &1}
      ) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
    |> broadcast(:updated)
  end

  def update_product_image(%Product{} = product, attrs) do
    product
    |> Product.image_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    product
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:orders,
      name: :orders_product_id_fkey,
      message: "This product cant be deleted, because users have bought it!"
    )
    |> Repo.delete()
    |> broadcast(:deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Parzival.Store.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(params \\ %{})

  def list_orders(opts) when is_list(opts) do
    Order
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_orders(flop) do
    Flop.validate_and_run(Order, flop, for: Order)
  end

  def list_orders(%{} = flop, opts) when is_list(opts) do
    Order
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id, opts \\ []) do
    Order
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  def purchase_product(user, product) do
    Multi.new()
    |> Multi.update(
      :update_balance,
      User.balance_changeset(user, %{balance: user.balance - product.price})
    )
    |> Multi.update(
      :update_stock,
      Product.stock_changeset(product, %{stock: product.stock - 1})
    )
    |> Multi.insert(:insert, %Order{user_id: user.id, product_id: product.id})
    |> Repo.transaction()
    |> case do
      {:ok, transaction} ->
        broadcast({:ok, transaction.update_stock}, :product_purchased)

      {:error, _transaction, changeset, _} ->
        {:error, changeset}
    end
  end

  def subscribe(topic)
      when topic in ["product_purchased", "product_updated", "product_deleted"] do
    Phoenix.PubSub.subscribe(Parzival.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:product_purchased] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "product_purchased", {event, product.stock})
    {:ok, product}
  end

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:product_updated] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "product_updated", {event, product})
    {:ok, product}
  end

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:product_deleted] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "product_deleted", {event, product})
    {:ok, product}
  end

  alias Parzival.Store.Boost

  @doc """
  Returns the list of boosts.

  ## Examples

      iex> list_boosts()
      [%Boost{}, ...]

  """
  def list_boosts(params \\ %{})

  def list_boosts(opts) when is_list(opts) do
    Boost
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_boosts(flop) do
    Flop.validate_and_run(Boost, flop, for: Boost)
  end

  def list_boosts(%{} = flop, opts) when is_list(opts) do
    Boost
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Boost)
  end

  @doc """
  Gets a single boost.

  Raises `Ecto.NoResultsError` if the Boost does not exist.

  ## Examples

      iex> get_boost!(123)
      %Boost{}

      iex> get_boost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_boost!(id), do: Repo.get!(Boost, id)

  # This function assumes the existance of a boost of type skip_task
  def get_skip_task_boost do
    Boost
    |> where([b], b.type == :skip_task)
    |> Repo.one()
  end

  @doc """
  Creates a boost.

  ## Examples

      iex> create_boost(%{field: value})
      {:ok, %Boost{}}

      iex> create_boost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_boost(attrs \\ %{}) do
    %Boost{}
    |> Boost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a boost.

  ## Examples

      iex> update_boost(boost, %{field: new_value})
      {:ok, %Boost{}}

      iex> update_boost(boost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_boost(%Boost{} = boost, attrs) do
    boost
    |> Boost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a boost.

  ## Examples

      iex> delete_boost(boost)
      {:ok, %Boost{}}

      iex> delete_boost(boost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_boost(%Boost{} = boost) do
    Repo.delete(boost)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking boost changes.

  ## Examples

      iex> change_boost(boost)
      %Ecto.Changeset{data: %Boost{}}

  """
  def change_boost(%Boost{} = boost, attrs \\ %{}) do
    Boost.changeset(boost, attrs)
  end

  alias Parzival.Store.Item

  def purchase_boost(user, boost) do
    Multi.new()
    |> Multi.update(
      :update_balance,
      User.balance_changeset(user, %{balance: user.balance - boost.price})
    )
    |> Multi.insert(:insert, %Item{user_id: user.id, boost_id: boost.id})
    |> Repo.transaction()
    |> case do
      {:ok, transaction} ->
        {:ok, transaction}

      {:error, _transaction, changeset, _} ->
        {:error, changeset}
    end
  end

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items(params \\ %{})

  def list_items(opts) when is_list(opts) do
    Item
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_items(flop) do
    Flop.validate_and_run(Item, flop, for: Item)
  end

  def list_items(%{} = flop, opts) when is_list(opts) do
    Item
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Item)
  end

  def list_inventory(opts) when is_list(opts) do
    from(i in Item,
      where: is_nil(i.expires_at) or i.expires_at > ^NaiveDateTime.utc_now()
    )
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  def has_skip_task?(user_id) do
    Item
    |> where([i], i.user_id == ^user_id)
    |> join(:inner, [i], b in Boost, on: i.boost_id == b.id)
    |> where([i, b], b.type == :skip_task)
    |> Repo.exists?()
  end
end
