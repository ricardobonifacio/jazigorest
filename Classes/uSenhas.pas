unit uSenhas;

interface

type
  TSenhas = class
     FLogin: String;
     FSenha: String;
  private

  public
    property Login: String read FLogin write FLogin;
    property Senha: String read FSenha write FSenha;
    function ValidaUsuario(strLogin: String; strSenha: String): Boolean;
    function Descriptografar(ValStr: String): String;
    function Cripto(ValStr: String; Tipo: Integer):String;
end;

implementation

uses uDM;

function TSenhas.ValidaUsuario(strLogin: String; strSenha: String): Boolean;
begin
  DM.qrGenerica.SQL.Clear;
  DM.qrGenerica.SQL.Add('SELECT S.LOGISENH, S.PASSSENH');
  DM.qrGenerica.SQL.Add('  FROM SENHAS S              ');
  DM.qrGenerica.SQL.Add(' WHERE S.LOGISENH = :LOGISENH');
  DM.qrGenerica.Parameters.ParamByName('LOGISENH').Value := strLogin;
  DM.qrGenerica.Open;

  if DM.qrGenerica.isEmpty then
     Result := False
  else
  begin
     if Descriptografar(DM.qrGenerica.FieldByName('PASSSENH').AsString) = strSenha then
        Result := True
     else
        Result := False;
  end;

end;

function TSenhas.Descriptografar(ValStr: String):String;
Var
  piI      :Integer;
  psResult :String;
begin
  For piI:= 1 To Length(ValStr) Do
    psResult := psResult + Chr(Ord(ValStr[piI])-3);

  Result := psResult;
end;

function TSenhas.Cripto(ValStr: String; Tipo: Integer):String;
Var
   piI      :Integer;
   psResult :String;
begin
   If (Tipo = 1) Then
      For piI:= 1 To Length(ValStr) Do
         psResult := psResult + Chr(Ord(ValStr[piI])+3)
   Else
      For piI:= 1 To Length(ValStr) Do
         psResult := psResult + Chr(Ord(ValStr[piI])-3);

   Result := psResult;
end;

end.
