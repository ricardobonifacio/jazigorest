unit uWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer,
  Web.WebFileDispatcher, Web.HTTPProd,
  DSAuth,
  Datasnap.DSProxyJavaScript, IPPeerServer, Datasnap.DSMetadata,
  Datasnap.DSServerMetadata, Datasnap.DSClientMetadata, Datasnap.DSCommonServer,
  Datasnap.DSHTTP;

type
  TWebModule1 = class(TWebModule)
    DSHTTPWebDispatcher1: TDSHTTPWebDispatcher;
    WebFileDispatcher1: TWebFileDispatcher;
    DSProxyGenerator1: TDSProxyGenerator;
    DSServerMetaDataProvider1: TDSServerMetaDataProvider;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebFileDispatcher1BeforeDispatch(Sender: TObject;
      const AFileName: string; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

uses uServerMethods, uServerContainer, Web.WebReq, uPrincipal;

{$R *.dfm}

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  strPorta: String;
begin
  strPorta := frmPrincipal.edPorta.Caption;

  Response.Content := '<html> ' + #13#10 +
                      '   <title>Web Service - SmartFarma</title>' + #13#10 +
                      '   <heading/> ' + #13#10 +
                      '     <body> ' + #13#10 +
                      '       <h1>JaziGO</h1> </br>' + #13#10 +
                      '       <a href="http://localhost:' + strPorta + '/datasnap/rest/TSMetodo/GetClientes">1 - GetClientes</a> </br>' + #13#10 +
                      '       <a href="http://localhost:' + strPorta + '/datasnap/rest/TSMetodo/GetInumados">2 - GetInumados</a> </br>' + #13#10 +
                      '       <a href="http://localhost:' + strPorta + '/datasnap/rest/TSMetodo/GetJazigo">3 - GetJazigo</a> </br>' + #13#10 +
                      '       <a href="http://localhost:' + strPorta + '/datasnap/rest/TSMetodo/GetParcelas">4 - GetParcelas</a> </br>' + #13#10 +
                      '     </body> ' + #13#10 +
                      '</html> ';
end;

procedure TWebModule1.WebFileDispatcher1BeforeDispatch(Sender: TObject;
  const AFileName: string; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  D1, D2: TDateTime;
begin
  Handled := False;
  if SameFileName(ExtractFileName(AFileName), 'serverfunctions.js') then
    if not FileExists(AFileName) or (FileAge(AFileName, D1) and FileAge(WebApplicationFileName, D2) and (D1 < D2)) then
    begin
      DSProxyGenerator1.TargetDirectory := ExtractFilePath(AFileName);
      DSProxyGenerator1.TargetUnitName := ExtractFileName(AFileName);
      DSProxyGenerator1.Write;
    end;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  DSHTTPWebDispatcher1.Server := DSServer;
  if DSServer.Started then
  begin
    DSHTTPWebDispatcher1.DbxContext := DSServer.DbxContext;
    DSHTTPWebDispatcher1.Start;
  end;
end;

initialization
finalization
  Web.WebReq.FreeWebModules;

end.

