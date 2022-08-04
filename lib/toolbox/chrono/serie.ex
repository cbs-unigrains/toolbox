defmodule Toolbox.Chrono.Serie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "series" do
    field :code, :string
    field :comment, :string
    field :label, :string
    field :periodicity, :string
    field :rubrique, :string
    field :secteur, :string
    field :type, :string
    field :unit, :id

    timestamps()
  end

  @doc false
  def changeset(serie, attrs) do
    serie
    |> cast(attrs, [:secteur, :rubrique, :code, :label, :periodicity, :comment, :type])
    |> validate_required([:secteur, :rubrique, :code, :label, :periodicity, :comment, :type])
  end
end
