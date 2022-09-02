defmodule Toolbox.Chrono.Rubrique do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rubriques" do
    field :name, :string

    belongs_to :secteur, Toolbox.Chrono.Secteur

    timestamps()
  end

  @doc false
  def changeset(rubrique, attrs) do
    rubrique
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
