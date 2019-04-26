unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UBasePrincipal, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.BatchMove.Text, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.DataSet, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrmPrincipal = class(TFrmBasePrincipal)
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    MemSQLSelecionar: TMemo;
    Panel2: TPanel;
    BtnExpArqExecutaSQL: TSpeedButton;
    Splitter1: TSplitter;
    DtsExporta: TDataSource;
    BtnExpArqSalvar: TSpeedButton;
    Panel3: TPanel;
    DBGrid2: TDBGrid;
    BtnImpArquivo: TSpeedButton;
    DtsBatchMove: TDataSource;
    BtnImpArquivoAbrir: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnExpArqExecutaSQLClick(Sender: TObject);
    procedure BtnExpArqSalvarClick(Sender: TObject);
    procedure BtnImpArquivoClick(Sender: TObject);
    procedure BtnImpArquivoAbrirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  UConnection, UEXportaArquivo, UImportaArquivo;

{$R *.dfm}

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  inherited;

  PageControl2.ActivePageIndex := 0;
end;

procedure TFrmPrincipal.BtnExpArqExecutaSQLClick(Sender: TObject);
begin
  DtmExportaArquivo.SelecionarDados(MemSQLSelecionar.Text);
end;

procedure TFrmPrincipal.BtnExpArqSalvarClick(Sender: TObject);
begin
  DtmExportaArquivo.SalvarArquivoTexto;
end;

procedure TFrmPrincipal.BtnImpArquivoAbrirClick(Sender: TObject);
begin
  DtmImportaArquivo.QryBatchMove.Close;
  DtmImportaArquivo.QryBatchMove.Open;
end;

procedure TFrmPrincipal.BtnImpArquivoClick(Sender: TObject);
begin
  DtmImportaArquivo.ImportarArquivo;
end;

end.
