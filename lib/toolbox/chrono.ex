defmodule Toolbox.Chrono do
  @moduledoc """
  The Chrono context.
  """

  import Ecto.Query, warn: false
  alias Toolbox.Repo

  alias Toolbox.Chrono.Unit

  @doc """
  Returns the list of unit.

  ## Examples

      iex> list_unit()
      [%Unit{}, ...]

  """
  def list_unit do
    Repo.all(Unit)
  end

  @doc """
  Gets a single unit.

  Raises `Ecto.NoResultsError` if the Unit does not exist.

  ## Examples

      iex> get_unit!(123)
      %Unit{}

      iex> get_unit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_unit!(id), do: Repo.get!(Unit, id)

  @doc """
  Creates a unit.

  ## Examples

      iex> create_unit(%{field: value})
      {:ok, %Unit{}}

      iex> create_unit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_unit(attrs \\ %{}) do
    %Unit{}
    |> Unit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a unit.

  ## Examples

      iex> update_unit(unit, %{field: new_value})
      {:ok, %Unit{}}

      iex> update_unit(unit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_unit(%Unit{} = unit, attrs) do
    unit
    |> Unit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a unit.

  ## Examples

      iex> delete_unit(unit)
      {:ok, %Unit{}}

      iex> delete_unit(unit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_unit(%Unit{} = unit) do
    Repo.delete(unit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking unit changes.

  ## Examples

      iex> change_unit(unit)
      %Ecto.Changeset{data: %Unit{}}

  """
  def change_unit(%Unit{} = unit, attrs \\ %{}) do
    Unit.changeset(unit, attrs)
  end

  alias Toolbox.Chrono.Serie

  @doc """
  Returns the list of series.

  ## Examples

      iex> list_series()
      [%Serie{}, ...]

  """
  def list_series do
    Repo.all(Serie)
  end

  @doc """
  Gets a single serie.

  Raises `Ecto.NoResultsError` if the Serie does not exist.

  ## Examples

      iex> get_serie!(123)
      %Serie{}

      iex> get_serie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_serie!(id), do: Repo.get!(Serie, id)

  @doc """
  Creates a serie.

  ## Examples

      iex> create_serie(%{field: value})
      {:ok, %Serie{}}

      iex> create_serie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_serie(attrs \\ %{}) do
    %Serie{}
    |> Serie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a serie.

  ## Examples

      iex> update_serie(serie, %{field: new_value})
      {:ok, %Serie{}}

      iex> update_serie(serie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_serie(%Serie{} = serie, attrs) do
    serie
    |> Serie.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a serie.

  ## Examples

      iex> delete_serie(serie)
      {:ok, %Serie{}}

      iex> delete_serie(serie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_serie(%Serie{} = serie) do
    Repo.delete(serie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking serie changes.

  ## Examples

      iex> change_serie(serie)
      %Ecto.Changeset{data: %Serie{}}

  """
  def change_serie(%Serie{} = serie, attrs \\ %{}) do
    Serie.changeset(serie, attrs)
  end

  alias Toolbox.Chrono.Secteur

  @doc """
  Returns the list of secteurs.

  ## Examples

      iex> list_secteurs()
      [%Secteur{}, ...]

  """
  def list_secteurs do
    Repo.all(Secteur)
  end

  @doc """
  Gets a single secteur.

  Raises `Ecto.NoResultsError` if the Secteur does not exist.

  ## Examples

      iex> get_secteur!(123)
      %Secteur{}

      iex> get_secteur!(456)
      ** (Ecto.NoResultsError)

  """
  def get_secteur!(id), do: Repo.get!(Secteur, id)

  @doc """
  Creates a secteur.

  ## Examples

      iex> create_secteur(%{field: value})
      {:ok, %Secteur{}}

      iex> create_secteur(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_secteur(attrs \\ %{}) do
    %Secteur{}
    |> Secteur.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a secteur.

  ## Examples

      iex> update_secteur(secteur, %{field: new_value})
      {:ok, %Secteur{}}

      iex> update_secteur(secteur, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_secteur(%Secteur{} = secteur, attrs) do
    secteur
    |> Secteur.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a secteur.

  ## Examples

      iex> delete_secteur(secteur)
      {:ok, %Secteur{}}

      iex> delete_secteur(secteur)
      {:error, %Ecto.Changeset{}}

  """
  def delete_secteur(%Secteur{} = secteur) do
    Repo.delete(secteur)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking secteur changes.

  ## Examples

      iex> change_secteur(secteur)
      %Ecto.Changeset{data: %Secteur{}}

  """
  def change_secteur(%Secteur{} = secteur, attrs \\ %{}) do
    Secteur.changeset(secteur, attrs)
  end

  alias Toolbox.Chrono.Rubrique

  @doc """
  Returns the list of rubriques.

  ## Examples

      iex> list_rubriques()
      [%Rubrique{}, ...]

  """
  def list_rubriques do
    Repo.all(Rubrique)
  end

  @doc """
  Gets a single rubrique.

  Raises `Ecto.NoResultsError` if the Rubrique does not exist.

  ## Examples

      iex> get_rubrique!(123)
      %Rubrique{}

      iex> get_rubrique!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rubrique!(id), do: Repo.get!(Rubrique, id)

  @doc """
  Creates a rubrique.

  ## Examples

      iex> create_rubrique(%{field: value})
      {:ok, %Rubrique{}}

      iex> create_rubrique(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rubrique(attrs \\ %{}) do
    %Rubrique{}
    |> Rubrique.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rubrique.

  ## Examples

      iex> update_rubrique(rubrique, %{field: new_value})
      {:ok, %Rubrique{}}

      iex> update_rubrique(rubrique, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rubrique(%Rubrique{} = rubrique, attrs) do
    rubrique
    |> Rubrique.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rubrique.

  ## Examples

      iex> delete_rubrique(rubrique)
      {:ok, %Rubrique{}}

      iex> delete_rubrique(rubrique)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rubrique(%Rubrique{} = rubrique) do
    Repo.delete(rubrique)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rubrique changes.

  ## Examples

      iex> change_rubrique(rubrique)
      %Ecto.Changeset{data: %Rubrique{}}

  """
  def change_rubrique(%Rubrique{} = rubrique, attrs \\ %{}) do
    Rubrique.changeset(rubrique, attrs)
  end
end
