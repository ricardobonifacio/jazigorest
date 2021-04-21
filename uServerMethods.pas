unit uServerMethods;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  Rest.Json, DBXJSON, uclCliente;

type
  TSMetodo = class(TDSServerModule)
  private
    { Private declarations }
  public
    { Public declarations }
    function GetArray(teste: String): TJSONArray;
    function GetClientes: TJSONArray;
    function GetClientesPagina(strCliente1: String; strCliente2: String): TJSONArray;
    function GetInumados: TJSONArray;
    function GetJazigo: TJSONArray;
    function GetParcelas: TJSONArray;
    function carregarClientes(strCliente1: String; strCliente2: String): String;
    function carregarInumados: String;
    function carregarJazigos: String;
    function carregarPagamentos: String;
    function formataTelefone(fone: String): String;
    function formataCEP(cep: String): String;
    function retirarCaracteres(texto: String): String;
  end;

implementation

{$R *.dfm}

uses uDM, uPrincipal;

{ TServerMethods1 }

function TSMetodo.GetArray(teste: String): TJSONArray;
var
  LJsonArr: TJSONArray;
  JSonStr: String;
begin
  JSonStr := '[{"id":1,"nome":"Joao teste","dados":""},'+
             ' {"id":1,"nome":"Maria teste","dados":""}]';
  LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;

  Result := LJsonArr;
end;

function TSMetodo.GetClientesPagina(strCliente1, strCliente2: String): TJSONArray;
var
  LJsonArr: TJSONArray;
  JSonStr: String;
begin
  JSonStr := carregarClientes(strCliente1, strCliente2);

  LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;

  Result := LJsonArr;
end;

function TSMetodo.GetClientes: TJSONArray;
var
  LJsonArr: TJSONArray;
  JSonStr: String;
begin
  JSonStr := carregarClientes('', '');

  LJsonArr := TJSONArray.Create;
  //LJsonArr.
  LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;
  //LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;

  Result := LJsonArr;
end;

function TSMetodo.GetInumados: TJSONArray;
var
  LJsonArr: TJSONArray;
  JSonStr: String;
begin
  JSonStr := carregarInumados;

  LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;

  Result := LJsonArr;
end;

function TSMetodo.GetJazigo: TJSONArray;
var
  LJsonArr: TJSONArray;
  JSonStr: String;
begin
  JSonStr := carregarJazigos;

  LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;

  Result := LJsonArr;
end;

function TSMetodo.GetParcelas: TJSONArray;
var
  LJsonArr: TJSONArray;
  JSonStr: String;
begin
  JSonStr := carregarPagamentos;

  LJsonArr :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSonStr),0) as TJSONArray;

  Result := LJsonArr;
end;

function TSMetodo.retirarCaracteres(texto: String): String;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸Ò˝¿¬ ‘€√’¡…Õ”⁄«‹—›@:∫™';
  SemAcento = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY--oa';
var
  x: Cardinal;
begin;
  for x := 1 to Length(texto) do
  try
    if (Pos(texto[x], ComAcento) <> 0) then
      texto[x] := SemAcento[ Pos(texto[x], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro no processo.');
  end;

  Result := texto;
end;

function TSMetodo.carregarClientes(strCliente1: String; strCliente2: String): String;
var
  vClientes, strTop: String;
  cont: integer;
begin
  if frmPrincipal.ckDemonstracao.Checked = True then
     strTop := ' TOP 10000 ';
  DM.qrGenerica.SQL.Clear;
  DM.qrGenerica.SQL.Add('SELECT ' + strTop + ' C.CODICLIE, C.NOMECLIE, C.DATACADA, SUBSTRING(C.CPFCLIE, 1, 6) CPF,        ');
  DM.qrGenerica.SQL.Add('       C.TILORESI, C.LOGRRESI, T.DESCRICAO + '' '' + L.DESCRICAO + '', '' + C.NUMERESI ENDERECO, ');
  DM.qrGenerica.SQL.Add('       C.COMPRESI, B.DESCRICAO BAIRRO, CI.DESCRICAO CIDADE, C.CEPRESI,                           ');
  DM.qrGenerica.SQL.Add('	      C.FONERESI, C.FONECOME, C.CELURESI, C.DATANASC, '' '' INUMADO                             ');
  DM.qrGenerica.SQL.Add('  FROM CLIENTES C                                                                                ');
  DM.qrGenerica.SQL.Add(' INNER JOIN TIPOLOGRADOURO T ON T.ID = C.TILORESI                                                ');
  DM.qrGenerica.SQL.Add(' INNER JOIN LOGRADOURO L ON L.ID = C.LOGRRESI                                                    ');
  DM.qrGenerica.SQL.Add(' INNER JOIN BAIRRO B ON B.ID = C.BAIRRESI                                                        ');
  DM.qrGenerica.SQL.Add(' INNER JOIN CIDADE CI ON CI.ID = C.CIDARESI                                                      ');
  DM.qrGenerica.SQL.Add(' WHERE 1 = 1                                                                                     ');
  DM.qrGenerica.SQL.Add('   AND C.CODICLIE IN (SELECT CODICLIE FROM CONTRATOS C1 WHERE C1.STATCONT = ''A'')               ');
  DM.qrGenerica.SQL.Add('   AND C.CODICLIE IN (SELECT C2.CODICLIE FROM CONTJAZI C2 WHERE C2.CODICLIE = C.CODICLIE)        ');

  if (strCliente1 <> '') and (strCliente2 <> '') then
     DM.qrGenerica.SQL.Add(' AND CODICLIE BETWEEN ' + QuotedStr(strCliente1) + ' AND ' + QuotedStr(strCliente2));

  DM.qrGenerica.SQL.Add(' ORDER BY C.CODICLIE                                                                             ');

  DM.qrGenerica.Open;
  while Not DM.qrGenerica.Eof do
  begin
    if vClientes <> '' then
       vClientes := vClientes + ',';
    vClientes := vClientes +
                 '{"codiclie":"'   + DM.qrGenerica.FieldByName('CODICLIE').AsString + '",' +
                  '"nomeclie":"'   + DM.qrGenerica.FieldByName('NOMECLIE').AsString + '",' +
                  '"cadastro":"'   + DM.qrGenerica.FieldByName('DATACADA').AsString + '",' +
                  '"cpf":"'        + DM.qrGenerica.FieldByName('CPF').AsString + '",' +
                  '"endereco":"'   + DM.qrGenerica.FieldByName('ENDERECO').AsString + '",' +
                  '"complem":"'    + retirarCaracteres(DM.qrGenerica.FieldByName('COMPRESI').AsString) + '",' +
                  '"bairro":"'     + retirarCaracteres(DM.qrGenerica.FieldByName('BAIRRO').AsString) + '",' +
                  '"cidade":"'     + DM.qrGenerica.FieldByName('CIDADE').AsString + '",' +
                  '"cepresi":"'    + retirarCaracteres(DM.qrGenerica.FieldByName('CEPRESI').AsString) + '",' +
                  '"foneresi":"'   + formataTelefone(DM.qrGenerica.FieldByName('FONERESI').AsString) + '",' +
                  '"fonecome":"'   + formataTelefone(DM.qrGenerica.FieldByName('FONECOME').AsString) + '",' +
                  '"celuresi":"'   + formataTelefone(DM.qrGenerica.FieldByName('CELURESI').AsString) + '",' +
                  '"nascimento":"' + DM.qrGenerica.FieldByName('DATANASC').AsString + '",' +
                  '"inumado":"'    + retirarCaracteres(DM.qrGenerica.FieldByName('INUMADO').AsString) + '"}';
    DM.qrGenerica.Next;
  end;

  if DM.qrGenerica.isEmpty then
     vClientes := '{"codiclie":""'   +
                   '"nomeclie":""'   +
                   '"cadastro":""'   +
                   '"cpf":""'        +
                   '"endereco":""'   +
                   '"complem":""'    +
                   '"bairro":""'     +
                   '"cidade":""'     +
                   '"cepresi":""'    +
                   '"foneresi":""'   +
                   '"fonecome":""'   +
                   '"celuresi":""'   +
                   '"nascimento":""' +
                   '"inumado":""}';

  frmPrincipal.XMLMemo.Lines.Clear;
  frmPrincipal.XMLMemo.Lines.Add(vClientes);
  result := '[' + vClientes + ']';
end;

function TSMetodo.carregarInumados: String;
var
  vInumados, strTOP, strSituacao: String;
  cont: integer;
begin
  if frmPrincipal.ckDemonstracao.Checked = True then
     strTOP := ' TOP 20 ';

  DM.qrGenerica.SQL.Clear;
  DM.qrGenerica.SQL.Add('SELECT ' + strTOP + ' CJ.CODICLIE, I.CODIINUM, I.NOMEINUM,      ');
  DM.qrGenerica.SQL.Add('       I.CPFINUM, i.datafale,                                   ');
  DM.qrGenerica.SQL.Add('       (SELECT TOP 1 ''SETOR: '' + J.PRIMPART + '' '' +         ');
  DM.qrGenerica.SQL.Add('	                    ''QUADRA: '' + J.SEGUPART + '' '' +        ');
  DM.qrGenerica.SQL.Add('					            ''JAZIGO: '' + J.TERCPART                  ');
  DM.qrGenerica.SQL.Add('	         FROM JAZIGOS J WHERE J.CODIJAZI = CODIESTR) DESCRICAO ');
  DM.qrGenerica.SQL.Add('  FROM CONTJAZI CJ                                              ');
  DM.qrGenerica.SQL.Add(' INNER JOIN PROCINFO P WITH(NOLOCK) ON P.CODIESTR = CJ.CODIJAZI ');
  DM.qrGenerica.SQL.Add(' INNER JOIN INUMADOS I WITH(NOLOCK) ON I.CODIINUM = P.CODIINUM  ');
  DM.qrGenerica.SQL.Add(' WHERE 1 = 1                                                    ');
  DM.qrGenerica.SQL.Add('   AND I.ULTITIPO NOT IN (''EC'', ''CR'')                       ');
  DM.qrGenerica.SQL.Add('   AND (P.ORDEPROC = (SELECT TOP 1 P1.ORDEPROC                  ');
  DM.qrGenerica.SQL.Add('                        FROM PROCINFO P1                        ');
  DM.qrGenerica.SQL.Add('                       WHERE P1.CODIINUM = P.CODIINUM           ');
  DM.qrGenerica.SQL.Add('                       ORDER BY ORDEPROC DESC))                 ');
  DM.qrGenerica.SQL.Add(' ORDER BY CJ.CODICLIE                                           ');
  DM.qrGenerica.Open;

  cont := 1;
  while Not DM.qrGenerica.Eof do
  begin
    if vInumados <> '' then
       vInumados := vInumados + ',';
    vInumados := vInumados + '{"codiclie":"' + DM.qrGenerica.FieldByName('CODICLIE').AsString + '",' +
                              '"codiinum":"' + DM.qrGenerica.FieldByName('CODIINUM').AsString + '",' +
                              '"nomeinum":"' + DM.qrGenerica.FieldByName('NOMEINUM').AsString + '",' +
                              '"cpfinum":"' + DM.qrGenerica.FieldByName('CODIINUM').AsString + '",' +
                              '"falecimento":"' + DM.qrGenerica.FieldByName('datafale').AsString + '",' +
                              '"descricao":"' + DM.qrGenerica.FieldByName('DESCRICAO').AsString + '"}';
    DM.qrGenerica.Next;
  end;
  result := '[' + vInumados + ']';
end;

function TSMetodo.carregarJazigos: String;
var
  vJazigos, strTOP, strSituacao: String;
  cont: integer;
begin
  if frmPrincipal.ckDemonstracao.Checked = True then
     strTOP := ' TOP 20 ';

  DM.qrGenerica.SQL.Clear;

  DM.qrGenerica.SQL.Add('DECLARE                                                  ');
  DM.qrGenerica.SQL.Add('   @OPCAOJAZI VARCHAR(3)                                 ');
  DM.qrGenerica.SQL.Add('BEGIN                                                    ');
  DM.qrGenerica.SQL.Add('   SET @OPCAOJAZI = (SELECT TOP 1 OPCAJAZI FROM CONFSGC) ');

  DM.qrGenerica.SQL.Add('   SELECT ' + strTOP + ' CJ.CODICLIE, J.CODIJAZI,                                                    ');

  DM.qrGenerica.SQL.Add('         (CASE WHEN @OPCAOJAZI = ''SQF''                                                                       ');
  DM.qrGenerica.SQL.Add('	              THEN (RTRIM(J.PRIMPART) + '' - '' + RTRIM(J.SEGUPART) + '' - '' + RTRIM(J.TERCPART) + '' - '' + ');
  DM.qrGenerica.SQL.Add('				              RTRIM(J.QUARPART) + '' - '' + RTRIM(J.QUINPART))                                          ');
  DM.qrGenerica.SQL.Add('			          WHEN @OPCAOJAZI = ''AQJ''                                                                       ');
  DM.qrGenerica.SQL.Add('			          THEN (RTRIM(J.PRIMPART) + '' - '' + RTRIM(J.SEGUPART) + '' - '' + RTRIM(J.TERCPART) + '' - '' + ');
  DM.qrGenerica.SQL.Add('                     RTRIM(J.QUARPART))                                                                        ');
  DM.qrGenerica.SQL.Add('               ELSE (''SETOR '' + RTRIM(J.PRIMPART) + ''   QUADRA '' + RTRIM(J.SEGUPART) +                     ');
  DM.qrGenerica.SQL.Add('				              ''  JAZIGO '' + RTRIM(J.TERCPART)) END) INFOJAZI,                                         ');

  DM.qrGenerica.SQL.Add('           (CASE WHEN @OPCAOJAZI = ''SQF''                                                           ');
  DM.qrGenerica.SQL.Add('		             THEN (RTrim(j.primpart))                                                             ');
  DM.qrGenerica.SQL.Add('				         WHEN @OPCAOJAZI = ''AQJ''                                                            ');
  DM.qrGenerica.SQL.Add('				         THEN (RTrim(j.quarpart))                                                             ');
  DM.qrGenerica.SQL.Add('				         ELSE RTrim(j.primpart) END) SETOR,                                                   ');
  DM.qrGenerica.SQL.Add('                                                                                                     ');
  DM.qrGenerica.SQL.Add('           (CASE WHEN @OPCAOJAZI = ''SQF''                                                           ');
  DM.qrGenerica.SQL.Add('		             THEN (RTrim(j.segupart))                                                             ');
  DM.qrGenerica.SQL.Add('        				 WHEN @OPCAOJAZI = ''AQJ''                                                            ');
  DM.qrGenerica.SQL.Add('        				 THEN (RTrim(j.segupart))                                                             ');
  DM.qrGenerica.SQL.Add('        				 ELSE RTrim(j.segupart) END) QUADRA,                                                  ');
  DM.qrGenerica.SQL.Add('                                                                                                     ');
  DM.qrGenerica.SQL.Add('           (CASE WHEN @OPCAOJAZI = ''SQF''                                                           ');
  DM.qrGenerica.SQL.Add('    		         THEN (RTrim(j.tercpart) + '' - '' + RTrim(j.quarpart) + '' - '' + RTrim(j.quinpart)) ');
  DM.qrGenerica.SQL.Add('        				 WHEN @OPCAOJAZI = ''AQJ''                                                            ');
  DM.qrGenerica.SQL.Add('        				 THEN (RTrim(j.tercpart) + '' - '' + RTrim(j.quarpart))                               ');
  DM.qrGenerica.SQL.Add('        				 ELSE RTrim(j.tercpart) END) JAZIGO_ID,                                               ');

  DM.qrGenerica.SQL.Add('           (SELECT TOP 1 T.GAVETIJA                                                        ');
  DM.qrGenerica.SQL.Add('    	         FROM TIPOJAZI T WITH(NOLOCK)                                                 ');
  DM.qrGenerica.SQL.Add('    		      WHERE T.CODITIJA = J.CODITIJA) NUM_GAVETAS,                                   ');
  DM.qrGenerica.SQL.Add('           (COUNT(P.CODIESTR) OVER(PARTITION BY P.CODIESTR)) GAVE_OCUPADA,                 ');
  DM.qrGenerica.SQL.Add('    	   P.NUMEGAVE, I.CODIINUM, I.NOMEINUM,                                                ');

  DM.qrGenerica.SQL.Add('   	   (CASE WHEN P.TIPOPROC = ''IN'' THEN ''Inumado''                                    ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''RE'' THEN ''Reinumado''                                  ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''EC'' THEN ''Exumado para outro cemitÈrio''               ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''EJ'' THEN ''Exumado para outro jazigo''                  ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''EP'' THEN ''Exumado para o prÛprio jazigo''              ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''EO'' THEN ''Exumado para ossu·rio''                      ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''CR'' THEN ''CremaÁ„o''                                   ');
  DM.qrGenerica.SQL.Add('              WHEN P.TIPOPROC = ''EX'' THEN ''Exumado para outro ossu·rio'' END) TIPOPROC, ');

  DM.qrGenerica.SQL.Add('    	   I.DATANASC, I.DATAFALE, P.DATAPROC,                                                ');
  DM.qrGenerica.SQL.Add('    	   I.PAIINUM, I.MAEINUM,                                                              ');
  DM.qrGenerica.SQL.Add('    	   (SELECT TOP 1 DESCGRAU FROM GRAUPARE GP WHERE GP.CODIGRAU = I.CODIGRAU) PARENTESCO ');
  DM.qrGenerica.SQL.Add('      FROM CONTJAZI CJ WITH(NOLOCK)                                                        ');
  DM.qrGenerica.SQL.Add('     INNER JOIN JAZIGOS J WITH(NOLOCK) ON J.CODIJAZI = CJ.CODIJAZI                         ');
  DM.qrGenerica.SQL.Add('      LEFT JOIN PROCINFO P WITH(NOLOCK) ON P.CODIESTR = CJ.CODIJAZI                        ');
  DM.qrGenerica.SQL.Add('           AND (P.ORDEPROC = (SELECT TOP 1 P1.ORDEPROC                                     ');
  DM.qrGenerica.SQL.Add('                                FROM PROCINFO P1                                           ');
  DM.qrGenerica.SQL.Add('                               WHERE P1.CODIINUM = P.CODIINUM                              ');
  DM.qrGenerica.SQL.Add('                               ORDER BY ORDEPROC DESC))                                    ');
  DM.qrGenerica.SQL.Add('      LEFT JOIN INUMADOS I WITH(NOLOCK) ON I.CODIINUM = P.CODIINUM                         ');
  DM.qrGenerica.SQL.Add('     WHERE 1 = 1                                                                           ');
  DM.qrGenerica.SQL.Add('       AND I.ULTITIPO NOT IN (''EC'', ''CR'')                                              ');
  DM.qrGenerica.SQL.Add('       AND CJ.CODICLIE IN (SELECT C1.CODICLIE FROM CONTRATOS C1 WHERE C1.STATCONT = ''A'') ');
  DM.qrGenerica.SQL.Add('     ORDER BY CJ.CODICLIE, P.NUMEGAVE                                                      ');
  DM.qrGenerica.SQL.Add('END                                                                                        ');
  DM.qrGenerica.Open;

  cont := 1;
  while Not DM.qrGenerica.Eof do
  begin
    if Trim(DM.qrGenerica.FieldByName('NOMEINUM').AsString) <> '' then
       strSituacao := 'Ocupado'
    else
       strSituacao := 'Livre';

    if vJazigos <> '' then
       vJazigos := vJazigos + ',';
    vJazigos := vJazigos + '{"codigo":"'           + DM.qrGenerica.FieldByName('CODIJAZI').AsString + '",'+
                            '"descricao":"'        + DM.qrGenerica.FieldByName('INFOJAZI').AsString + '",'+
                            '"codiclie":"'         + DM.qrGenerica.FieldByName('CODICLIE').AsString + '",'+
                            '"quadra":"'           + DM.qrGenerica.FieldByName('QUADRA').AsString + '",'+
                            '"setor":"'            + DM.qrGenerica.FieldByName('SETOR').AsString + '",'+
                            '"numero_gaveta":"'    + DM.qrGenerica.FieldByName('NUMEGAVE').AsString + '",'+
                            '"gavetas_ocupadas":"' + DM.qrGenerica.FieldByName('GAVE_OCUPADA').AsString + '",'+
                            '"jazigoid":"'         + DM.qrGenerica.FieldByName('JAZIGO_ID').AsString + '",'+
                            '"situacao":"'         + strSituacao + '",';

    if DM.qrGenerica.FieldByName('DATAFALE').AsString <> '' then
       vJazigos := vJazigos + '"falecido":"' + FormatDateTime('dd/mm/yyyy', DM.qrGenerica.FieldByName('DATAFALE').AsDateTime) + '",'
    else
       vJazigos := vJazigos + '"falecido":" ",';

    if DM.qrGenerica.FieldByName('DATAPROC').AsString <> '' then
       vJazigos := vJazigos + '"dtprocedimento":"' + FormatDateTime('dd/mm/yyyy', DM.qrGenerica.FieldByName('DATAPROC').AsDateTime) + '",'
    else
       vJazigos := vJazigos + '"dtprocedimento":" ",';

    if DM.qrGenerica.FieldByName('DATANASC').AsString <> '' then
       vJazigos := vJazigos + '"nascimento":"' + FormatDateTime('dd/mm/yyyy', DM.qrGenerica.FieldByName('DATANASC').AsDateTime) + '",'
    else
       vJazigos := vJazigos + '"nascimento":" "';

    if DM.qrGenerica.FieldByName('DATAFALE').AsString <> '' then
       vJazigos := vJazigos + '"falecimento":"' + FormatDateTime('dd/mm/yyyy', DM.qrGenerica.FieldByName('DATAFALE').AsDateTime) + '",'
    else
       vJazigos := vJazigos + '"falecimento":" "';

    vJazigos := vJazigos + '"inumado":"'         + DM.qrGenerica.FieldByName('NOMEINUM').AsString + '",' +
                           '"procedimento":"'    + DM.qrGenerica.FieldByName('TIPOPROC').AsString + '",' +
                           '"pai":"'             + DM.qrGenerica.FieldByName('PAIINUM').AsString + '",' +
                           '"mae":"'             + DM.qrGenerica.FieldByName('MAEINUM').AsString + '",' +
                           '"parentesco":"'      + DM.qrGenerica.FieldByName('PARENTESCO').AsString + '"}';
    DM.qrGenerica.Next;
  end;

  result := '[' + vJazigos + ']';
end;

function TSMetodo.carregarPagamentos: String;
var
  vPagamentos, strTOP: String;
  cont: integer;
begin
  if frmPrincipal.ckDemonstracao.Checked = True then
     strTOP := ' TOP 100 ';

  DM.qrGenerica.SQL.Clear;
  DM.qrGenerica.SQL.Add('SELECT ' + strTOP + ' P.DATAVENC VENCIMENTO, ORDEPAGA,            ');
  DM.qrGenerica.SQL.Add('       P.VALODOCU, P.CODIINDI, I.DESCINDI, P.CODICLIE             ');
  DM.qrGenerica.SQL.Add('  FROM PAGAMENTOS P                                               ');
  DM.qrGenerica.SQL.Add(' INNER JOIN INDICES I ON I.CODIINDI = P.CODIINDI                  ');
  DM.qrGenerica.SQL.Add(' WHERE P.DATAPAGA IS NULL                                         ');
  DM.qrGenerica.SQL.Add('   AND CONVERT(DATE, P.DATAVENC) >= CONVERT(DATE, GETDATE()- 365) ');
  DM.qrGenerica.SQL.Add('   AND CONVERT(DATE, P.DATAVENC) <= CONVERT(DATE, GETDATE())      ');
  DM.qrGenerica.SQL.Add('   AND P.CODICLIE IN (SELECT C.CODICLIE                           ');
  DM.qrGenerica.SQL.Add('                        FROM CONTRATOS C                          ');
  DM.qrGenerica.SQL.Add('                       WHERE C.STATCONT = ''A'')                  ');
  DM.qrGenerica.SQL.Add(' ORDER BY P.CODICLIE, P.DATAVENC                                  ');
  DM.qrGenerica.Open;

  cont := 1;
  while Not DM.qrGenerica.Eof do
  begin
    if vPagamentos <> '' then
       vPagamentos := vPagamentos + ',';
    vPagamentos := vPagamentos + '{"id":"' + IntToStr(cont) +
                   '","indice":"' + DM.qrGenerica.FieldByName('DESCINDI').AsString +
                   '","venc":"' + FormatDateTime('dd/mm/yyyy', DM.qrGenerica.FieldByName('VENCIMENTO').AsDateTime) +
                   ' (' + DM.qrGenerica.FieldByName('ORDEPAGA').AsString + ')' +
                   '","vl":"' + FormatFloat('0.00', DM.qrGenerica.FieldByName('VALODOCU').AsFloat) +
                   '","clie":"' + DM.qrGenerica.FieldByName('CODICLIE').AsString + '"}';
    inc(cont);
    DM.qrGenerica.Next;
  end;

  result := '[' + vPagamentos + ']';
end;

function TSMetodo.formataCEP(cep: String): String;
var
  cepResult: String;
begin
  result := '';

  if cep = '' then
     Exit;

  cepResult := Copy(cep, 1, 2) + ' ' +
               Copy(cep, 3, 3) + '-' +
               Copy(cep, 6, 3);

  result := cepResult;
end;

function TSMetodo.formataTelefone(fone: String): String;
var
  foneResult: String;
begin
  fone := StringReplace(fone, ' ', '', [rfReplaceAll]);

  foneResult := fone;
  if Copy(foneResult, 1, 2) = '00' then
     foneResult := Copy(fone, 3, 12);

  if Length(foneResult) = 11 then
     foneResult := '(' + Copy(foneResult, 1, 2) + ')' +
                   Copy(foneResult, 3, 5) + '-' +
                   Copy(foneResult, 8, 4)
  else
     foneResult := '(' + Copy(foneResult, 1, 2) + ')' +
                   Copy(foneResult, 3, 4) + '-' +
                   Copy(foneResult, 7, 4);

  if fone = '' then
     foneResult := '';

  result := foneResult;
end;

end.

