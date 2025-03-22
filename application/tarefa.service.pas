unit tarefa.service;

interface

uses tarefa, itarefa.repository;

type
  TTarefaService = class
  private
    FTarefaRepository: ITarefaRepository;

  public
    constructor Create(ATarefaRepository: ITarefaRepository);
    function ListarPorUsuarioId(const AUsuarioId: Integer): TArray<TTarefa>;
    procedure Criar(const ATarefa: TTarefa);
    procedure Concluir(const AId: Integer);
    procedure Excluir(const AId: Integer);

  end;

implementation

constructor TTarefaService.Create(ATarefaRepository: ITarefaRepository);
begin
  inherited Create;
  FTarefaRepository := ATarefaRepository;
end;

function TTarefaService.ListarPorUsuarioId(const AUsuarioId: Integer): TArray<TTarefa>;
begin
  Result := FTarefaRepository.BuscarPorUsuarioId(AUsuarioId);
end;

procedure TTarefaService.Criar(const ATarefa: TTarefa);
begin
  FTarefaRepository.Salvar(ATarefa);
end;

procedure TTarefaService.Concluir(const AId: Integer);
begin
  FTarefaRepository.Concluir(AId);
end;

procedure TTarefaService.Excluir(const AId: Integer);
begin
  FTarefaRepository.Excluir(AId);
end;

end.

