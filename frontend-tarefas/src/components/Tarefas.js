import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

function Tarefas() {
  const [tarefas, setTarefas] = useState([]);
  const [novaTarefa, setNovaTarefa] = useState('');
  const navigate = useNavigate();

  // Função para buscar tarefas do usuário logado (ID 1)
  const buscarTarefas = async () => {
    try {
      const response = await fetch('http://localhost:9000/tarefas?usuarioId=1');
      const data = await response.json();
      setTarefas(data);
    } catch (error) {
      console.error('Erro ao buscar tarefas:', error);
    }
  };

  // Busca as tarefas ao carregar a página
  useEffect(() => {
    buscarTarefas();
  }, []);

  const handleCriarTarefa = async () => {
    if (novaTarefa.trim() === '') {
      alert('Digite uma descrição para a tarefa.');
      return;
    }

    try {
      const response = await fetch('http://localhost:9000/tarefas', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          usuario_id: 1, // Usuário fixo da sessão (ID 1)
          descricao: novaTarefa, // Descrição da tarefa
          concluida: 0, // Sempre 0 ao criar uma nova tarefa
        }),
      });

      if (response.ok) {
        // Busca as tarefas novamente para atualizar a lista
        await buscarTarefas();
        setNovaTarefa(''); // Limpa o campo de entrada
        alert('Tarefa criada com sucesso!');
      } else {
        alert('Erro ao criar tarefa.');
      }
    } catch (error) {
      console.error('Erro:', error);
    }
  };

  const handleConcluirTarefa = async (id) => {
    try {
      const response = await fetch(`http://localhost:9000/tarefas/${id}/concluir`, {
        method: 'PUT',
      });

      if (response.ok) {
        // Atualiza a lista de tarefas após concluir
        await buscarTarefas();
      } else {
        alert('Erro ao concluir tarefa.');
      }
    } catch (error) {
      console.error('Erro:', error);
    }
  };

  const handleExcluirTarefa = async (id) => {
    try {
      const response = await fetch(`http://localhost:9000/tarefas/${id}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        // Atualiza a lista de tarefas após excluir
        await buscarTarefas();
      } else {
        alert('Erro ao excluir tarefa.');
      }
    } catch (error) {
      console.error('Erro:', error);
    }
  };

  const handleSair = () => {
    navigate('/'); // Volta para a página principal
  };

  return (
    <div style={styles.container}>
      <h2>Tarefas do Usuário</h2>
      <div style={styles.form}>
        <input
          type="text"
          value={novaTarefa}
          onChange={(e) => setNovaTarefa(e.target.value)}
          placeholder="Nova tarefa"
          style={styles.input}
        />
        <button onClick={handleCriarTarefa} style={styles.buttonCriar}>
          Criar Tarefa
        </button>
      </div>
      <ul style={styles.lista}>
        {tarefas.map((tarefa) => (
          <li key={tarefa.id} style={styles.item}>
            <span style={tarefa.concluida ? styles.concluida : {}}>
              {tarefa.descricao}
            </span>
            <div style={styles.botoes}>
              <button
                onClick={() => handleConcluirTarefa(tarefa.id)}
                style={
                  tarefa.concluida
                    ? styles.buttonConcluirDesabilitado
                    : styles.buttonConcluir
                }
                disabled={tarefa.concluida}
              >
                Concluir
              </button>
              <button
                onClick={() => handleExcluirTarefa(tarefa.id)}
                style={styles.buttonExcluir}
              >
                Excluir
              </button>
            </div>
          </li>
        ))}
      </ul>
      <button onClick={handleSair} style={styles.buttonSair}>
        Sair
      </button>
    </div>
  );
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '20px',
    backgroundColor: '#f0f0f0',
  },
  form: {
    display: 'flex',
    gap: '10px',
    marginBottom: '20px',
  },
  input: {
    padding: '8px',
    fontSize: '16px',
    borderRadius: '5px',
    border: '1px solid #ccc',
    width: '300px',
  },
  buttonCriar: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#007bff',
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  lista: {
    listStyle: 'none',
    padding: '0',
    width: '100%',
    maxWidth: '600px',
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '10px',
    borderBottom: '1px solid #ccc',
    backgroundColor: '#fff',
    borderRadius: '5px',
    marginBottom: '10px',
  },
  concluida: {
    textDecoration: 'line-through',
    color: '#888',
  },
  botoes: {
    display: 'flex',
    gap: '10px',
  },
  buttonConcluir: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#28a745', // Verde
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  buttonConcluirDesabilitado: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#6c757d', // Cinza
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'not-allowed', // Cursor desabilitado
  },
  buttonExcluir: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#dc3545', // Vermelho
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  buttonSair: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#6c757d', // Cinza
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
    marginTop: '20px',
  },
};

export default Tarefas;