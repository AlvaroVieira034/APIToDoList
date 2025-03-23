program ApiToDoList;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.Jhonson,
  Horse.Session,
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  database.config in 'configuration\database.config.pas',
  usuario in 'domain\usuario.pas',
  tarefa in 'domain\tarefa.pas',
  usuario.repository in 'infrastructure\usuario.repository.pas',
  usuario.service in 'application\usuario.service.pas',
  usuario.controller in 'presentation\usuario.controller.pas',
  tarefa.repository in 'infrastructure\tarefa.repository.pas',
  tarefa.service in 'application\tarefa.service.pas',
  tarefa.controller in 'presentation\tarefa.controller.pas',
  usuario.session in 'session\usuario.session.pas',
  itarefa.repository in 'domain\itarefa.repository.pas',
  Horse.CORS in 'Horse-CORS\Horse.CORS.pas',
  iusuario.repository in 'domain\iusuario.repository.pas',
  usuario.dto in 'domain\usuario.dto.pas',
  tarefa.dto in 'domain\tarefa.dto.pas';

var Params: TStrings;

begin
  try
    Params := TStringList.Create;
    try
      Writeln('Versão do Horse: ', THorse.Version);

      Params.Add('Database=bancoteste.db');

      THorse.Use(CORS);

      // Configura o FireDac para usar o Driver do SQLite
      FDManager.AddConnectionDef('SQLiteConnection', 'SQLite', Params);

      // Configura o middleware de sessão
      //THorse.Use(Session);

      // Configura a API
      THorse.Use(Jhonson()); // Middleware para JSON

      // Rotas de usuário
      THorse.Post('/login', Usuario.Controller.Login);
      THorse.Post('/cadastro', Usuario.Controller.Cadastrar);
      THorse.Get('/usuarios', Usuario.Controller.ListarUsuarios);

      // Rotas de tarefas
      THorse.Get('/tarefas', Tarefa.Controller.ListarTarefas);
      THorse.Post('/tarefas', Tarefa.Controller.CriarTarefa);
      THorse.Put('/tarefas/:id', Tarefa.Controller.ConcluirTarefa);
      THorse.Delete('/tarefas/:id', Tarefa.Controller.ExcluirTarefa);

      // Inicia o servidor na porta 9000
      THorse.Listen(9000);
    finally
      Params.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
