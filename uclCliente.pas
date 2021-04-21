unit uclCliente;

interface

type
  TCliente = class
  private
    Fid: integer;
    FNome: string;
    FDados: string;
    procedure Setid(const Value: integer);
    procedure SetNome(const Value: string);
    procedure SetDados(const Value: string);
    public
      property id: integer read Fid write Setid;
      property Nome: string read FNome write SetNome;
      property Dados: string read FDados write SetDados;
  end;

  TClienteArray = array of TCliente;

implementation

{ TCliente }

procedure TCliente.SetDados(const Value: string);
begin
  FDados := Value;
end;

procedure TCliente.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TCliente.SetNome(const Value: string);
begin
  FNome := Value;
end;

end.
