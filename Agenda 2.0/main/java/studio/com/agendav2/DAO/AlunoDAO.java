package studio.com.agendav2.DAO;

import java.util.ArrayList;
import java.util.List;

import studio.com.agendav2.model.Aluno;

public class AlunoDAO {
    //Simulação de persistencia de dados (enquanto nossa aplicacao estiver viva)
    private static final List<Aluno> alunos = new ArrayList<>();
    private static int contadorId = 1;


    public void salva(Aluno aluno) {
        aluno.setId(contadorId);
        alunos.add(aluno);
        contadorId++;
    }

    public void edita(Aluno aluno){
        Aluno alunoEncontrado = buscaAlunoId(aluno);
        if(alunoEncontrado != null){
            int posicaoAluno = alunos.indexOf(alunoEncontrado);
            alunos.set(posicaoAluno, aluno);
        }
    }

    private Aluno buscaAlunoId(Aluno aluno) {
        Aluno alunoEncontrado = null;
        for (Aluno a:
             alunos) {
            if(a.getId() == aluno.getId()){
                return a;
            }
        }
        return alunoEncontrado;
    }

    //Ele devolve uma copia da lista pra ninguem ter acesso a ela
    public List<Aluno> devolveAlunos() {
        return new ArrayList<>(alunos);
    }

    public void remove(Aluno aluno) {
        Aluno alunoDevolvido = buscaAlunoId(aluno);
        if(alunoDevolvido != null){
            alunos.remove(alunoDevolvido);
        }
    }
}
