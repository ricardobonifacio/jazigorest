unit uConfiguracoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrConfiguracoes = class(TForm)
    pnBotoPrin: TPanel;
    sbNovo: TSpeedButton;
    sbGravar: TSpeedButton;
    sbFech: TSpeedButton;
    Label1: TLabel;
    edPorta: TEdit;
    Label2: TLabel;
    edLink: TEdit;
    Label3: TLabel;
    edUsuario: TEdit;
    Label4: TLabel;
    edSenha: TEdit;
    Label5: TLabel;
    edServidor: TEdit;
    Label6: TLabel;
    edBanco: TEdit;
    procedure sbNovoClick(Sender: TObject);
    procedure sbGravarClick(Sender: TObject);
    procedure sbFechClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure abrirConfig;
  public
    { Public declarations }
  end;

var
  FrConfiguracoes: TFrConfiguracoes;

implementation

uses uSenhas, uDM, uPrincipal;

{$R *.dfm}

procedure TFrConfiguracoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrConfiguracoes.FormCreate(Sender: TObject);
begin
  abrirConfig;
end;

procedure TFrConfiguracoes.FormDestroy(Sender: TObject);
begin
    FrConfiguracoes := nil;
end;

procedure TFrConfiguracoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 113 then
     sbNovo.Click;
  if Key = 114 then
     sbGravar.Click;
end;

procedure TFrConfiguracoes.sbFechClick(Sender: TObject);
begin
  Close;
end;

procedure TFrConfiguracoes.sbGravarClick(Sender: TObject);
var
  Arquivo: TStringList;
  NomeArquivo, strConexao: String;
  Senha: TSenhas;
begin
  Arquivo := TStringList.Create;
  NomeArquivo := ExtractFilePath(Application.ExeName) + 'confWS.ini';
  DeleteFile(NomeArquivo);
  Arquivo.Add(edPorta.Text);       // 0
  Arquivo.Add(edLink.Text);        // 1
  Arquivo.Add(Senha.Cripto(edSenha.Text, 1));       // 2
  Arquivo.Add(edUsuario.Text);     // 3
  Arquivo.Add(edBanco.Text);       // 4
  Arquivo.Add(edServidor.Text);    // 5
  Arquivo.SaveToFile(NomeArquivo);
  Arquivo := nil;
  ShowMessage('Configurações salvas com sucesso.');

  strConexao := 'Provider=SQLOLEDB.1;' +
                'Persist Security Info=True;' +
                'Use Procedure for Prepare=1;' +
                'Auto Translate=True;Packet Size=4096;' +
                'Password=' + edSenha.Text + ';' +
                'User ID=' + edUsuario.Text + ';' +
                'Initial Catalog=' + edBanco.Text + ';' +
                'Data Source=' + edServidor.Text + ';';
  DM.Conexao.Connected := False;
  DM.Conexao.ConnectionString := strConexao;
  try
     frmPrincipal.edPorta.Caption := edPorta.Text;
     frmPrincipal.edLink.Caption := edLink.Text;
     DM.Conexao.Connected := True;
     ShowMessage('Banco conectado');
  except
     ShowMessage('Não foi possível conectar o banco.' + #13#10 + #13#10 +
                 'Refaça as configurações.');
  end;
end;

procedure TFrConfiguracoes.abrirConfig;
var
  Arquivo: TStringList;
  Senha: TSenhas;
begin
  if FileExists(ExtractFilePath(Application.ExeName) + 'confWS.ini') then
  begin
     Arquivo := TStringList.Create;
     Arquivo.LoadFromFile(ExtractFilePath(Application.ExeName) + 'confWS.ini');

     if Arquivo.Count > 0 then
        edPorta.Text   := Arquivo.Strings[0];
     if Arquivo.Count > 1 then
        edLink.Text    := Arquivo.Strings[1];
     if Arquivo.Count > 2 then
        edSenha.Text   := Senha.Descriptografar(Arquivo.Strings[2]);
     if Arquivo.Count > 3 then
        edUsuario.Text := Arquivo.Strings[3];
     if Arquivo.Count > 4 then
        edBanco.Text   := Arquivo.Strings[4];
     if Arquivo.Count > 5 then
        edServidor.Text:= Arquivo.Strings[5];

     Arquivo := nil;
  end;
end;

procedure TFrConfiguracoes.sbNovoClick(Sender: TObject);
begin
  edPorta.Text   := '';
  edLink.Text    := '';
  edSenha.Text   := '';
  edUsuario.Text := '';
  edBanco.Text   := '';
  edServidor.Text:= '';
end;

end.
