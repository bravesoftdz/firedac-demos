unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UBasePrincipal, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Samples.Spin, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls;

type
  TFrmPrincipal = class(TFrmBasePrincipal)
    BtnInsercaoNormal: TButton;
    BtnInsercaoArrayDML: TButton;
    edtQuantidadeItens: TSpinEdit;
    Memo1: TMemo;
    Label11: TLabel;
    procedure BtnInsercaoNormalClick(Sender: TObject);
    procedure BtnInsercaoArrayDMLClick(Sender: TObject);
  private
    procedure LimparTabelaArrayDML;
    procedure LogMsg(const AString: string);
  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  UFBConnection;

{$R *.dfm}

procedure TFrmPrincipal.LogMsg(const AString: string);
begin
  Memo1.Lines.Add(AString)
end;

procedure TFrmPrincipal.LimparTabelaArrayDML;
var
  CountItens: Integer;
begin
  CountItens := DtmFBConnection.FDConnection1.ExecSQL('delete from ARRAYDML');

  LogMsg(
    Format('%d registro(s) apagado(s) da tabela, come�ando inser��o', [CountItens])
  );
end;

procedure TFrmPrincipal.BtnInsercaoNormalClick(Sender: TObject);
var
  I: Integer;
  Inicio: TDateTime;
begin
  DtmFBConnection.FDConnection1.StartTransaction;
  try
    LogMsg('');
    LimparTabelaArrayDML;

    Inicio := Now;
    for I := 0 to edtQuantidadeItens.Value -1 do
    begin
      DtmFBConnection.FDConnection1.ExecSQL(
        'INSERT INTO ARRAYDML (ID, DESCRICAO) VALUES (?, ?)',
        [I + 1, Format('Descri��o do item %d', [I + 1])],
        [ftInteger, ftString]
      )
    end;

    DtmFBConnection.FDConnection1.Commit;

    LogMsg('Itens inseridos corretamente, tempo: ' +
      FormatDateTime('hh:mm:ss:zzz', Now - Inicio)
    );
  except
    on E: Exception do
    begin
      DtmFBConnection.FDConnection1.Rollback;
      ShowMessage(
        'Ocorreu o seguinte erro durante a inser��o de itens: ' + sLineBreak +
        E.Message
      );
    end;
  end;
end;

procedure TFrmPrincipal.BtnInsercaoArrayDMLClick(Sender: TObject);
var
  I: Integer;
  QryInsert: TFDQuery;
  Inicio: TDateTime;
begin
  DtmFBConnection.FDConnection1.StartTransaction;
  try
    LogMsg('');
    LimparTabelaArrayDML;

    QryInsert := TFDQuery.Create(Self);
    try
      QryInsert.Connection := DtmFBConnection.FDConnection1;
      QryInsert.SQL.Text   := 'INSERT INTO ARRAYDML (ID, DESCRICAO) VALUES (:ID, :DESCRICAO)';

      Inicio := Now;
      QryInsert.Params.ArraySize := 0;
      for I := 0 to edtQuantidadeItens.Value -1 do
      begin
        QryInsert.Params.ArraySize := QryInsert.Params.ArraySize + 1;

        QryInsert.Params[0].AsIntegers[I] := I + 1;
        QryInsert.Params[1].AsStrings[I]  := Format('Descri��o do item %d', [I]);
      end;

      QryInsert.Execute(QryInsert.Params.ArraySize);
      DtmFBConnection.FDConnection1.Commit;

      LogMsg('Itens inseridos corretamente, tempo: ' +
        FormatDateTime('hh:mm:ss:zzz', Now - Inicio)
      );
    finally
      QryInsert.Free;
    end;
  except
    on E: Exception do
    begin
      DtmFBConnection.FDConnection1.Rollback;
      ShowMessage(
        'Ocorreu o seguinte erro durante a inser��o de itens: ' + sLineBreak +
        E.Message
      );
    end;
  end;
end;

end.
