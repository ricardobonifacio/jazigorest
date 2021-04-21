object DM: TDM
  OldCreateOrder = False
  Height = 287
  Width = 438
  object Conexao: TADOConnection
    CommandTimeout = 3000
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=sa;Initial Catalog=Data2CMS;Data Source=MARIACL' +
      'ARA;'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 40
    Top = 8
  end
  object qrGenerica: TADOQuery
    Connection = Conexao
    CommandTimeout = 3000
    Parameters = <>
    Left = 120
    Top = 8
  end
  object qrPesq: TADOQuery
    Parameters = <>
    Left = 192
    Top = 8
  end
end
