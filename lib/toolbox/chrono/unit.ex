defmodule Toolbox.Chrono.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "unit" do
    field :label, :string
    field :short_label, :string

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:label, :short_label])
    |> validate_required([:label, :short_label])
  end
end
