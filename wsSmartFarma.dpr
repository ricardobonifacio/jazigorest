program wsSmartFarma;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uServerMethods in 'uServerMethods.pas' {SMetodo: TDSServerModule},
  uServerContainer in 'uServerContainer.pas' {ServerContainer1: TDataModule},
  uWebModule in 'uWebModule.pas' {WebModule1: TWebModule},
  uclCliente in 'uclCliente.pas',
  uSenhas in 'Classes\uSenhas.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  uclKey in 'uclKey.pas',
  uConfiguracoes in 'uConfiguracoes.pas' {FrConfiguracoes};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
