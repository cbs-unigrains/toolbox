defmodule Toolbox.Efront do
  @moduledoc """
  The eFront context.
  """

  import Ecto.Query, warn: false
  alias Toolbox.EfrontRepo, as: Repo

  @doc """
  Returns the accruals.
  
  ## Examples
  
      iex> list_accruals()
      [%Unit{}, ...]
  
  """

  @accruals_query """
  SELECT R4.FUND AS Fund
    , R5.NAME AS Account
    , R1.SHORTNAME AS InstrumentCode
    , A.REFDATE AS ValueDate
    , R6.ACCOUNTNO AS AccountingNumber
    , R1.CURRENCY1 AS Currency
    , A.AMOUNT AS Amount
    , A.SHORTDESCR AS Label
    , R2.IQID AS TransactionId
    , A.IQID AS GLentryId
  FROM [efront].[dbo].[GLENTRY] A
    LEFT JOIN [efront].[dbo].[VCINVESTMENTINS] R1 ON R1.IQID=A.KEYID4
    LEFT JOIN [efront].[dbo].[VCINVESTMENT] R2 ON R2.IQID=R1.INVESTMENT
    LEFT JOIN [efront].[dbo].[SFAACCOUNT] R3 ON R3.IQID=R2.FIRM
    LEFT JOIN [efront].[dbo].[VCFUND] R4 ON R4.IQID=R2.FUND
    LEFT JOIN [efront].[dbo].[SFAACCOUNT] R5 ON R5.IQID=R2.ACCOUNT
    LEFT JOIN [efront].[dbo].[GLACCOUNT] R6 ON R6.IQID=A.ACCOUNT
    LEFT JOIN [efront].[dbo].[VCINVESTMENTOP] R7 ON R7.IQID=A.KEYID3
  WHERE A.ENTRYTYPE='REPORT'
    AND A.IQDELETED != 1
    AND (R7.EXPORTNUMBER != -1 OR R7.EXPORTNUMBER IS NULL)
    AND (R7.DRAFT = 0 OR R7.DRAFT IS NULL)
    AND A.USERTEXT2 is null
  order by  A.REFDATE, R5.NAME, R4.FUND, R1.SHORTNAME,R6.ACCOUNTNO, R2.IQID
  """
  def list_accruals do
    Repo.query(@accruals_query)
  end

  @doc """
  Returns the accruals.
  
  ## Examples
  
      iex> list_accruals()
      [%Unit{}, ...]
  
  """

  @cash_query """
  SELECT R4.FUND AS fund
    , R5.NAME AS account
    , R1.SHORTNAME AS instrument
    , FORMAT (A.REFDATE, 'yyyy-MM-dd') AS date
    , R6.ACCOUNTNO AS accounting
    , R1.CURRENCY1 AS currency
    , ROUND(A.AMOUNT, 2) AS amount
    , R2.IQID AS transaction_id
    , A.IQID AS glentry_id
  FROM [efront].[dbo].GLENTRY A
  LEFT JOIN [efront].[dbo].VCINVESTMENTINS R1 ON R1.IQID=A.KEYID4
  LEFT JOIN [efront].[dbo].VCINVESTMENTOP R2 ON R2.IQID=A.KEYID3
  LEFT JOIN [efront].[dbo].VCINVESTMENT R3 ON R3.IQID=R2.INVESTMENT
  LEFT JOIN [efront].[dbo].VCFUND R4 ON R4.IQID=R3.FUND
  LEFT JOIN [efront].[dbo].SFAACCOUNT R5 ON R5.IQID=R3.ACCOUNT
  LEFT JOIN [efront].[dbo].GLACCOUNT R6 ON R6.IQID=A.ACCOUNT
  WHERE	(A.ENTRYTYPE<>'REPORT' OR A.ENTRYTYPE IS NULL)
    AND A.IQDELETED != 1
    AND R4.IQID IS NOT NULL
    AND A.USERTEXT2 IS NULL
    AND (R2.EXPORTNUMBER != -1 OR R2.EXPORTNUMBER IS NULL)
    AND (R2.DRAFT = 0 OR R2.DRAFT IS NULL)
    AND A.USERTEXT2 is null
  ORDER BY A.REFDATE DESC, R5.NAME, R4.FUND, R1.SHORTNAME, R2.IQID, R6.ACCOUNTNO
  """
  def list_cash do
    {:ok, %{columns: columns, rows: rows, num_rows: num_rows}} = Repo.query(@cash_query)

    columns_atomed = for col <- columns, do: String.to_atom(col)
    lines = for row <- rows, do: Map.new(Enum.zip(columns_atomed, row))

    first_transaction_id = List.first(lines).transaction_id

    lines_with_index =
      lines
      |> Enum.map_reduce({first_transaction_id, 0}, fn x, acc ->
        idx =
          if x.transaction_id == elem(acc, 0) do
            elem(acc, 1)
          else
            elem(acc, 1) + 1
          end

        {{idx, x}, {x.transaction_id, idx}}
      end)
      |> elem(0)

    %{
      num_rows: num_rows,
      rows: lines,
      rows_with_index: lines_with_index
    }
  end
end
