unit uclKey;

interface

uses
   SysUtils, Windows, IniFiles, Forms, DateUtils, Controls;

type
  TTypeCryptography = (tcEncrypt, tcDecrypt);

  TKey = class
  private
    FDataLimite: string;
    FSerialGerado: string;
    FSerialConfir: string;
    FLastDayExp: Integer;
    procedure setFDataLimite(const Value: string);
    procedure setFSerialGerado(const Value: string);
    procedure SetSerialConfir(const Value: string);

    function getWinSystemDir: string;

  public
    property DataLimite: string read FDataLimite write setFDataLimite;
    property SerialGerado: string write setFSerialGerado;
    property SerialConfir: string write SetSerialConfir;
    property WinSystemDir: string read getWinSystemDir;
    property LastDayExp: Integer read FLastDayExp;

    function GeraSerial: string;
    function SerialConfirm: string;
    function SerialUnid(UnidStr: string): string;

    function ReadConfServ(Campo: string): string;
    function DataServ :TDateTime;

    function EncryptStr(StrValue: string; TypeCrypt: TTypeCryptography): string;

  end;

implementation

uses uDM;

function TKey.DataServ: TDateTime;
begin
  DM.qrPesq.Close();
  DM.QRPesq.SQL.Clear();

  DM.qrPesq.SQL.Add( 'SELECT GETDATE() AS DATA' );

  DM.qrPesq.Open();

  Result := DM.qrPesq.FieldByName( 'DATA' ).AsDateTime;
end;

function TKey.EncryptStr(StrValue: string; TypeCrypt: TTypeCryptography): string;
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  Dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  Range: Integer;

const
  Key: string = 'RYUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMMM4A4VZYW9KHJUI2347EJHJKDF3424SKL?K3LAKDJSL9RTIKJF';

begin
  if Trim(StrValue) = '' Then
  begin
    Result := '';
    Exit;
  end;

  Dest   := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  Range  := 256;

  case TypeCrypt of
    tcEncrypt: begin
                 Randomize;
                 OffSet := Random(Range);
                 Dest   := Format('%1.2x',[OffSet]);

                 for SrcPos := 1 to Length(StrValue) do
                 begin
                   SrcAsc := (Ord(StrValue[SrcPos]) + OffSet) mod 255;

                   if KeyPos < KeyLen then
                   begin
                     Inc(KeyPos);
                   end
                   else
                   begin
                     KeyPos := 1;
                   end;

                   SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
                   Dest   := Dest + Format('%1.2x',[SrcAsc]);
                   OffSet := SrcAsc;
                 end;
               end;
    tcDecrypt: begin
                 OffSet := StrToInt('$'+ copy(StrValue,1,2));
                 SrcPos := 3;

                 repeat

                   SrcAsc := StrToInt('$'+ copy(StrValue,SrcPos,2));

                   if (KeyPos < KeyLen) then
                   begin
                     Inc(KeyPos);
                   end
                   else
                   begin
                     KeyPos := 1;
                   end;

                   TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
                                      
                   if TmpSrcAsc <= OffSet then
                   begin
                     TmpSrcAsc := 255 + TmpSrcAsc - OffSet;
                   end
                   else
                   begin
                     TmpSrcAsc := TmpSrcAsc - OffSet;
                   end;

                   Dest   := Dest + Chr(TmpSrcAsc);
                   OffSet := SrcAsc;
                   SrcPos := SrcPos + 2;

                 until (SrcPos >= Length(StrValue));
               end;
  end;
  
  Result:= Dest;
end;

function TKey.GeraSerial: string;
const
  SeqCarac: array[0..10] of string = ('A','W','Y','Z','X','P','+','=','!','?','*');
begin
  Randomize;
  Result := SeqCarac[Random(9)] + IntToStr(Random(9)) + IntToStr(Random(9)) +
            SeqCarac[Random(9)] + IntToStr(Random(9)) + IntToStr(Random(9)) +
            SeqCarac[Random(9)] + SeqCarac[Random(9)] + IntToStr(Random(9)) +
            SeqCarac[Random(9)] + SeqCarac[Random(9)] + IntToStr(Random(9)) +
            IntToStr(Random(9)) + IntToStr(Random(9)) + IntToStr(Random(9)) +
            IntToStr(Random(9));
end;

function TKey.getWinSystemDir: string;
begin
  SetLength(Result, MAX_PATH);

  if GetWindowsDirectory(PChar(Result), MAX_PATH) > 0 then
  begin
    Result := string(PChar(Result));
  end
  else
  begin
    Result := '';
  end;
end;

function TKey.ReadConfServ(Campo: string): string;
begin
  DM.qrPesq.Close();
  DM.qrPesq.SQL.Clear();

  DM.qrPesq.SQL.Add( 'Select ' + campo + ' as Campo' );
  DM.qrPesq.SQL.Add( 'From configma' );

  DM.qrPesq.Open();

  Result := DM.qrPesq.FieldByName('Campo').AsString;
end;

function TKey.SerialConfirm: string;
var
  Data: string;
  aNumber: Integer;
  NumberConfEncrypt: string;
begin
  Data := Copy(FDataLimite,1,2) + Copy(FDataLimite,4,2) + Copy(FDataLimite,7,4);

  aNumber := StrToInt(Copy(FSerialGerado,2,1)) + StrToInt(Copy(FSerialGerado,6,1)) +
             StrToInt(Copy(FSerialGerado,9,1)) + StrToInt(Copy(FSerialGerado,12,1)) +
             StrToInt(Copy(FSerialGerado,15,1));

  NumberConfEncrypt := EncryptStr(Data + IntToStr(aNumber), tcEncrypt);

  Result := NumberConfEncrypt;
end;

function TKey.SerialUnid(UnidStr: string): string;
var
  Serial: DWord;
  DirLen,Flags: DWord;
  DLabel: array[0..11] of Char;
begin
  try
    GetVolumeInformation(PChar(UnidStr+'\'),DLabel,12,@Serial,DirLen,Flags,nil,0);
    Result := IntToHex(Serial,8);
  except
    Result := '';
  end;
end;

procedure TKey.setFDataLimite(const Value: string);
begin
  if Value = '  /  /    ' then
  begin
    raise Exception.Create('Informe a data limite.');
  end;

  try
    StrToDate(Value);
  except
    on E: EConvertError do
    begin
      raise Exception.Create('Data limite inválida.');
    end;

    on E: Exception do
    begin
      raise Exception.Create( 'Evento inesperado: ' + E.message );
    end;
  end;

  if StrToDate(Value) < Date() then
  begin
    raise Exception.Create( 'Data limite já ultrapassada.' );
  end;

  FDataLimite := Value;
end;

procedure TKey.setFSerialGerado(const Value: string);
begin
  if Length(Value) <> 20 then
  begin
    raise Exception.Create( 'Serial gerado inválido.' );
  end;

  try
    StrToInt(Copy(Value,2,1));
    StrToInt(Copy(Value,6,1));
    StrToInt(Copy(Value,9,1));
    StrToInt(Copy(Value,12,1));
    StrToInt(Copy(Value,16,1));
  except
    on E: EConvertError do
    begin
      raise Exception.Create(E.Message);
    end;

    on E: Exception do
    begin
      raise Exception.Create(E.message);
    end;
  end;

  FSerialGerado := Value;
end;

procedure TKey.SetSerialConfir(const Value: string);
begin
  if Trim(Value) = '' then
  begin
    raise Exception.Create('Serial inválido.');
  end;

  FSerialConfir := Value;
end;

end.

