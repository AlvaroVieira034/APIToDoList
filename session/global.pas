unit global;

interface

uses
  System.SysUtils, System.Classes;

var
  VersaoAPI: string;
  PortaServidor: Integer;
  UsuarioLogado: Integer;

implementation

initialization
  VersaoAPI := '1.0.1';
  PortaServidor := 9000;  // Porta padrão
  UsuarioLogado := 0;

end.

