package studio.com.agendav2.DAO;

import java.util.ArrayList;
import java.util.List;

import studio.com.agendav2.model.Aluno;

public class AlunoDAO {
    //Simulação de persistencia de dados (enquanto nossa aplicacao estiver viva)
    private static final List<Aluno> alunos = new ArrayList<>();

    public void salva(Aluno aluno) {
        alunos.add(aluno);
    }
    //Ele devolve uma copia da lista pra ninguem ter acesso a ela
    public List<Aluno> devolveAlunos() {
        return new ArrayList<>(alunos);
    }
}
