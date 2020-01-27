package studio.com.agendav2.ui.activity;

import android.content.Intent;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import studio.com.agendav2.DAO.AlunoDAO;
import studio.com.agendav2.R;

public class MainActivity extends AppCompatActivity {

    private final AlunoDAO dao = new AlunoDAO();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Setando titulo

        setTitle("Lista de Alunos");
        botaoFAB();

/****
 * ORGANIZADO NO ONRESUME()
        //Novo dao

       // AlunoDAO dao = new AlunoDAO();

        //Lista dos alunos

//        List<String> alunos = new ArrayList<>(Arrays.asList("Dacinho", "Extrinha", "Dede"));

        //List view, usada no lugar da View qualquer que é lançada
      //  ListView listaAlunos = findViewById(R.id.listinha);

        //Por simplicidade, em vez de listAdapter, faz arrayAdapter
        //setAdapter e um arrayadapter com this (essa activity)
    //    listaAlunos.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_expandable_list_item_1, dao.devolveAlunos()));
********/
    }

    private void botaoFAB() {
        //Organizar o fluxo do FAB

        FloatingActionButton botaoAdd = findViewById(R.id.fab_add_aluno);
        botaoAdd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                abreFormAluno();
            }
        });
    }

    private void abreFormAluno() {
        startActivity(new Intent(this, FormActivity.class));
    }

    @Override
    protected void onResume() {

        super.onResume();
        configuraLista();
    }

    private void configuraLista() {
        ListView listaAlunos = findViewById(R.id.listinha);

        //Por simplicidade, em vez de listAdapter, faz arrayAdapter
        //setAdapter e um arrayadapter com this (essa activity)
        listaAlunos.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_expandable_list_item_1, dao.devolveAlunos()));
    }
}
