unit uPrincipal;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, Vcl.ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    btConfig: TButton;
    Label2: TLabel;
    ckDemonstracao: TCheckBox;
    XMLMemo: TMemo;
    edPorta: TPanel;
    edLink: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure btConfigClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Winapi.ShellApi, Datasnap.DSSession, uConfiguracoes, uDM, uSenhas;

procedure TfrmPrincipal.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  edPorta.Enabled := not FServer.Active;
end;

procedure TfrmPrincipal.btConfigClick(Sender: TObject);
begin
  FrConfiguracoes := TFrConfiguracoes.Create(Self);
  FrConfiguracoes.ShowModal;
end;

procedure TfrmPrincipal.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [edPorta.Caption]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmPrincipal.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfrmPrincipal.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
  Arquivo: TStringList;
  strConexao: String;
  Senha: TSenhas;
begin
  if FileExists(ExtractFilePath(Application.ExeName) + 'confWS.ini') then
  begin
     Arquivo := TStringList.Create;
     Arquivo.LoadFromFile(ExtractFilePath(Application.ExeName) + 'confWS.ini');
     edPorta.Caption := Arquivo.Strings[0];
     edLink.Caption  := Arquivo.Strings[1];

     if (Arquivo.Count > 5) and (FileExists('C:\DEMO.TXT') = False) then
     begin
        strConexao := 'Provider=SQLOLEDB.1;' +
                      'Persist Security Info=True;' +
                      'Use Procedure for Prepare=1;' +
                      'Auto Translate=True;Packet Size=4096;' +
                      'Password=' + Senha.Descriptografar(Arquivo.Strings[2]) + ';' +
                      'User ID=' +  Arquivo.Strings[3] + ';' +
                      'Initial Catalog=' + Arquivo.Strings[4] + ';' +
                      'Data Source=' + Arquivo.Strings[5] + ';';
        DM.Conexao.Connected := False;
        DM.Conexao.ConnectionString := strConexao;

        try
           DM.Conexao.Connected := True;
        except
           btConfig.Click;
        end;
     end;
     Arquivo := nil;
  end;
end;

procedure TfrmPrincipal.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(edPorta.Caption);
    FServer.Active := True;
  end;
end;

end.
