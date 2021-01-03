unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ZConnection, ZDataset, ZSqlUpdate, rxdbgrid, rxctrls, IniFiles, DB;

type

  { TfrmExemploREDE }

  TfrmExemploREDE = class(TForm)
    btnConectar: TButton;
    btnGravaINI: TButton;
    btnLerINI: TButton;
    Button1: TButton;
    DataSource1: TDataSource;
    edtNOME: TEdit;
    edtFONE: TEdit;
    edtServidor: TEdit;
    edtPORTA: TEdit;
    edtUSUARIO: TEdit;
    edtSENHA: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    pnlTITULO: TPanel;
    pnptop: TPanel;
    pnpPrincipal: TPanel;
    pnpConexao: TPanel;
    RxDBGrid1: TRxDBGrid;
    rgBANCO: TRxRadioGroup;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZQuery1codigo: TLongintField;
    ZQuery1nome: TStringField;
    ZQuery1telefone: TStringField;
    ZUpdateSQL1: TZUpdateSQL;
    procedure btnConectarClick(Sender: TObject);
    procedure btnGravaINIClick(Sender: TObject);
    procedure btnLerINIClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure rgBANCOChangeBounds(Sender: TObject);
    procedure rgBANCOClick(Sender: TObject);
    procedure ZConnection1AfterConnect(Sender: TObject);
    procedure ZQuery1AfterDelete(DataSet: TDataSet);
    procedure ZQuery1AfterEdit(DataSet: TDataSet);
    procedure ZQuery1AfterPost(DataSet: TDataSet);
  private

  public

  end;

var
  frmExemploREDE: TfrmExemploREDE;
  cCaminhoEXE : string;

implementation

{$R *.lfm}

{ TfrmExemploREDE }

procedure TfrmExemploREDE.btnGravaINIClick(Sender: TObject);
var
  ArquivoINI: TIniFile;
begin
  ArquivoINI := TIniFile.Create(cCaminhoEXE+'Configuracao.ini');
  ArquivoINI.WriteString('Conexao', 'servidor', edtServidor.Text);
  ArquivoINI.WriteString('Conexao', 'porta', edtPORTA.Text);
  ArquivoINI.WriteString('Conexao', 'usuario', edtUSUARIO.Text);
  ArquivoINI.WriteString('Conexao', 'senha', edtSENHA.Text);
  ArquivoINI.WriteInteger('Conexao', 'BancoDeDados', rgBANCO.ItemIndex);

  ArquivoINI.Free;
end;

procedure TfrmExemploREDE.btnLerINIClick(Sender: TObject);
var
  ArquivoINI: TIniFile;
begin
  ArquivoINI           := TIniFile.Create(cCaminhoEXE+'Configuracao.ini');
  edtServidor.Text     := ArquivoINI.ReadString('Conexao', 'servidor', 'localhost');
  edtPORTA.text        := ArquivoINI.ReadString('Conexao', 'porta', '3306');
  edtUSUARIO.Text      := ArquivoINI.ReadString('Conexao', 'usuario', 'username');
  edtSENHA.Text        := ArquivoINI.ReadString('Conexao', 'senha', '1234');
  rgBANCO.ItemIndex    := ArquivoINI.ReadInteger('Conexao', 'BancoDeDados', 0);

  ArquivoINI.Free;
end;

procedure TfrmExemploREDE.Button1Click(Sender: TObject);
begin
  try
  ZQuery1.Insert;
  ZQuery1nome.Value:=edtNOME.Text;
  ZQuery1telefone.Value:=edtFONE.Text;
  ZQuery1.Post;

  except
    on e: Exception do
       begin
         ShowMessage('Erro ao incluir registro'+
         sLineBreak+e.Message+sLineBreak+e.ClassName);
         Application.Terminate;
       end;
  end;
  edtNOME.Clear;
  edtFONE.Clear;
end;

procedure TfrmExemploREDE.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if ZQuery1.Active then
     ZQuery1.Close;
  if ZConnection1.Connected then
     ZConnection1.Disconnect;
end;

procedure TfrmExemploREDE.FormCreate(Sender: TObject);
begin
  // c:\temp\teste\
  cCaminhoEXE:=ExtractFilePath(Application.ExeName);
end;

procedure TfrmExemploREDE.rgBANCOChangeBounds(Sender: TObject);
begin
end;

procedure TfrmExemploREDE.rgBANCOClick(Sender: TObject);
begin
    if rgBANCO.ItemIndex = 0 then
      begin
       edtPORTA.Text:='3306';
       edtUSUARIO.Text :='root';
      end
  else
    begin
     edtPORTA.Text:='5432';
     edtUSUARIO.Text :='postgres';
    end;
end;

procedure TfrmExemploREDE.ZConnection1AfterConnect(Sender: TObject);
begin
end;

procedure TfrmExemploREDE.ZQuery1AfterDelete(DataSet: TDataSet);
begin
    ZQuery1.ApplyUpdates;

end;

procedure TfrmExemploREDE.ZQuery1AfterEdit(DataSet: TDataSet);
begin
    ZQuery1.ApplyUpdates;

end;

procedure TfrmExemploREDE.ZQuery1AfterPost(DataSet: TDataSet);
begin
  ZQuery1.ApplyUpdates;
  ZQuery1.Refresh;
end;

procedure TfrmExemploREDE.btnConectarClick(Sender: TObject);
begin
  if ZConnection1.Connected then
     ZConnection1.Disconnect;

  if not ZConnection1.Connected then
     begin
       try
       ZConnection1.Database:='infocotidiano';
       if rgBANCO.ItemIndex = 0 then
          begin
            ZConnection1.Protocol  := 'MariaDB-10';
            ZConnection1.LibraryLocation:=cCaminhoEXE+'libmariadb.dll';
            pnlTITULO.Caption:='Infocotidiano -> Base MariaDB';
            pnlTITULO.Color:=clYellow;
          end
       else if rgBANCO.ItemIndex = 1 then
          begin
            ZConnection1.Protocol := 'postgresql';
            ZConnection1.LibraryLocation:=cCaminhoEXE+'libpq-10.dll';
            pnlTITULO.Caption:='Infocotidiano -> Base PostgreSQL';
            pnlTITULO.Color:=$00FFFF80;
          end;

       ZConnection1.HostName:=edtServidor.Text;
       ZConnection1.Port:=StrToIntDef(edtPORTA.Text,3306);
       ZConnection1.User:=edtUSUARIO.Text;
       ZConnection1.Password:=edtSENHA.Text;
       except
         on e: Exception do
            begin
              ShowMessage('Erro ao carregar parametros'+
              sLineBreak+e.Message+sLineBreak+e.ClassName);
              Application.Terminate;
            end;
       end;

       try
          ZConnection1.Connect;
       except
         on e: Exception do
            begin
              ShowMessage('Erro ao conectar a base'+
              sLineBreak+e.Message+sLineBreak+e.ClassName);
              Application.Terminate;
            end;
       end;
     end;
  if ZConnection1.Connected then
     begin
       try
       ZQuery1.Open;
       except
         on e: Exception do
            begin
              ShowMessage('Erro ao abrir a base'+
              sLineBreak+e.Message+sLineBreak+e.ClassName);
              Application.Terminate;
            end;
       end;
     end;

end;

end.

