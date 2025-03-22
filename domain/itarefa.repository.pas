unit itarefa.repository;

interface

uses
  Tarefa;

type
  ITarefaRepository = interface
    ['{9BD5E39C-A0FF-4483-969B-1A889D05FB1D}']
    function BuscarPorUsuarioId(const AUsuarioId: Integer): TArray<TTarefa>;
    procedure Salvar(const ATarefa: TTarefa);
    procedure Concluir(const AId: Integer);
    procedure Excluir(const AId: Integer);
  end;

implementation

end.
