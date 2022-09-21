defmodule Toolbox.Efront.Vcinvestmentop do
  use Ecto.Schema

  @primary_key {:IQID, :string, autogenerate: false}
  schema "VCINVESTMENTOP" do
    field :locked, :integer, source: :EXPORTNUMBER
  end
end
