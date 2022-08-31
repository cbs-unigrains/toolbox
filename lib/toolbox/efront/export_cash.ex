defmodule Toolbox.Efront.ExportCash do
  use Ecto.Schema

  @primary_key false
  schema "View_ExportCash" do
    field :code_coda, :string
    field :etablissement, :string
    field :date, :naive_datetime
    field :devise, :string
    field :accountnumber, :string
    field :code_comptable_ins, :string
    field :sens, :string
    field :amount, :float
    field :label, :string
    field :el3, :string
    field :el4, :string
    field :transaction_id, :string
    field :analytic, :string
    field :glentry, :string
  end
end
