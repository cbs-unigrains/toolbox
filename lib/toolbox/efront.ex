defmodule Toolbox.Efront do
  @moduledoc """
  The eFront context.
  """

  import Ecto.Query, warn: false
  alias Toolbox.EfrontRepo, as: Repo

  defdelegate authorize(action, user, params), to: Toolbox.Efront.Policy

  NimbleCSV.define(MyParser, separator: ";", escape: "\"")

  @doc """
  Returns the accruals.

  ## Examples

      iex> list_accruals()
      [%Unit{}, ...]

  """

  @accruals_query """
  SELECT R4.ABBREVIATION AS fund
    , R5.NAME AS account
    , R1.SHORTNAME AS instrument_code
    , A.REFDATE AS value_date
    , R6.ACCOUNTNO AS accounting_number
    , R1.CURRENCY1 AS currency
    , A.AMOUNT AS amount
    , A.SHORTDESCR AS label
    , R2.IQID AS transaction_id
    , A.IQID AS glentry_id
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
    {:ok, %{columns: columns, rows: rows, num_rows: num_rows}} = Repo.query(@accruals_query)

    if num_rows > 0 do
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
    else
      %{
        num_rows: 0,
        rows: [],
        rows_with_index: []
      }
    end
  end

  @doc """
  Returns the cash flows.

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

    if num_rows > 0 do
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
    else
      %{
        num_rows: 0,
        rows: [],
        rows_with_index: []
      }
    end
  end

  @doc """
  Export the gl entries to a file

  1058E8D0AEFD4AF5B147F2A6DA5B05B9;UNIG;001;29/06/2022;EUR;706010;       ;credit;6966.6400;29/06/2022 - Frais dossier reçus Action -  6966,6400 EUR - PAR-A-75352 01-UNG - Participation : SAGARD 4A;CI75352;I7535201;ZZZ-ZZZ-ZZZ
  1058E8D0AEFD4AF5B147F2A6DA5B05B9;UNIG;001;29/06/2022;EUR;472000;CI75352;debit ;6966.6400;29/06/2022 - Frais dossier reçus Action -  6966,6400 EUR - PAR-A-75352 01-UNG - Participation : SAGARD 4A;CI75352;I7535201;
  """
  @accounting_number_aux ~w(
    165100 168100 168700 168880 250000 261100 261800 266000 267400 267700
    267840 267890 271100 272100 273100 273200 273300 274100 274200 274600
    274900 275100 276821 276832 276833 276834 276840 277100 296000 296100
    296740 296784 297210 297310 297320 297330 297420 297821 297832 401100
    409100 411100 411101 411102 411103 411110 416000 419100 451000 451800
    455100 455800 458100 464000 467000 467100 467130 467200 472000 472100
    475000 503000 504000 506000 507000 508200 508800 511100 590300 590400
    801100 801800 802100 802800 803000 804000 804100 809100 809200 809300
    809400 809410
  )

  @accounting_number_analy ~w(
    201100 205000 207000 208100 211100 211200 211500 213100 213500 215400
    215700 218100 218200 218300 218400 218800 231000 232000 602210 604000
    605000 606110 606120 606130 606140 606300 606400 606410 606800 611000
    611100 611200 611300 611400 611500 611600 613000 613200 613210 613211
    613220 613500 614000 615200 615210 615500 615600 616100 616800 617100
    618100 618300 618500 621100 621400 622600 622610 622620 622630 622690
    622700 622800 623100 623300 623400 623410 623600 623700 623800 623810
    623820 624000 625100 625110 625120 625130 625200 625300 625500 625600
    625700 625710 625720 626100 626200 627100 627200 627800 628100 628200
    628300 628400 628500 631100 631200 633100 633200 633300 633400 633800
    635100 635110 635111 635120 635130 635140 635200 635400 635410 635800
    637100 637800 641100 641110 641200 641220 641240 641300 641310 641400
    641410 641430 641440 641450 641460 645100 645200 645300 645400 645500
    645510 645520 645530 645540 645700 645800 645900 645999 647200 647500
    647600 647699 647700 648000 649000 651100 651600 653000 654000 655100
    655500 658000 658100 658200 661160 661500 661600 661880 662830 662831
    662832 662833 664100 664200 666000 666100 666200 667100 667200 671200
    671400 671800 672000 675100 675200 675600 678800 681110 681120 681500
    681740 686620 686621 686622 686623 686624 686625 686626 686650 686651
    687100 687200 687250 687500 695100 695200 695400 698000 699000 706000
    706010 706020 706030 706100 706110 706120 706130 706200 706210 706220
    706400 708300 708310 708320 708800 708810 708811 708820 708830 708840
    722000 740000 741000 744000 751000 753000 753100 753300 755100 755500
    756000 758000 761110 761120 761700 762110 762200 762250 762260 762300
    762310 762320 762330 762340 762350 762360 762370 762380 762400 762460
    763000 763800 763810 764000 764100 765000 766000 766100 767100 767200
    768000 768200 768400 768800 771800 772000 775100 775200 775600 778800
    781110 781120 781500 781620 781740 786500 786620 786621 786622 786623
    786624 786625 786626 786650 786651 787200 787250 787300 787500 787600
    791000 801100 801800 802100 802800 803000 804000 804100 809100 809200
    809300 809400 809410
  )

  @file_path "C:/tmp/export_toolbox"
  def export_cash(entries) do
    query =
      from e in Toolbox.Efront.ExportCash,
        where: e.glentry in ^entries,
        order_by: [e.transaction_id, e.sens]

    timestamp = DateTime.utc_now() |> Calendar.strftime("%Y%m%d_%H%m%S")

    file = File.stream!(Path.join(@file_path, "#{timestamp} cash.csv"))
    rows = Repo.all(query)

    rows
    |> Enum.map(fn r ->
      [
        r.transaction_id,
        r.code_coda,
        r.etablissement,
        r.date |> Calendar.strftime("%d/%m/%Y"),
        r.devise,
        r.accountnumber,
        if r.accountnumber in @accounting_number_aux do
          r.code_comptable_ins
        else
          ""
        end,
        r.sens,
        r.amount |> :erlang.float_to_binary(decimals: 2),
        r.label,
        r.el3,
        r.el4,
        if r.accountnumber in @accounting_number_aux do
          r.analytic
        else
          ""
        end
      ]
    end)
    |> MyParser.dump_to_stream()
    |> Stream.into(file)
    |> Stream.run()
  end

  def export_accruals(entries) do
    query =
      from e in Toolbox.Efront.ExportAccruals,
        where: e.glentry in ^entries,
        order_by: [e.transaction_id, e.sens]

    timestamp = DateTime.utc_now() |> Calendar.strftime("%Y%m%d_%H%m%S")

    file = File.stream!(Path.join(@file_path, "#{timestamp} accruals.csv"))
    rows = Repo.all(query)

    rows
    |> Enum.map(fn r ->
      [
        r.transaction_id,
        r.code_coda,
        r.etablissement,
        r.date_valeur |> Calendar.strftime("%d/%m/%Y"),
        r.devise,
        r.accountnumber,
        if r.accountnumber in @accounting_number_aux do
          r.code_comptable_ins
        else
          ""
        end,
        r.sens,
        r.amount |> :erlang.float_to_binary(decimals: 2),
        r.label,
        r.el3,
        r.el4,
        if r.accountnumber in @accounting_number_aux do
          r.analytic
        else
          ""
        end
      ]
    end)
    |> MyParser.dump_to_stream()
    |> Stream.into(file)
    |> Stream.run()
  end
end
