defmodule Toolbox.Chrono.Secteur do
  use Ecto.Schema
  import Ecto.Changeset

  schema "secteurs" do
    field :name, :string
    has_many :rubriques, Toolbox.Chrono.Rubrique

    timestamps()
  end

  @doc false
  def changeset(secteur, attrs) do
    secteur
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
