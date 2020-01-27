package studio.com.agendav2.ui.activity;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;


import studio.com.agendav2.DAO.AlunoDAO;
import studio.com.agendav2.R;
import studio.com.agendav2.model.Aluno;

public class FormActivity extends AppCompatActivity {

    private EditText nome;
    private EditText telefone;
    private EditText email;
    private final AlunoDAO dao = new AlunoDAO();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form);

        setTitle("Novo Aluno");

        //Vai criar uma classe DAO para comportar toda informação que passaremos para as outras entidades do problema

        /*Preenchimento campos
        Ele deixou como final porque as variaveis estao sendo utilizadas como variaveis globais
        la no metodo onClick*/
        iniciaCampos();
        //Botao salvar
        botaoSalvar();
    }

    private void botaoSalvar() {
        Button botaoSalvar = findViewById(R.id.activity_form_save);

        //Chama setonClickListener (escutando) e cria uma classe anonima OnClickListener
        botaoSalvar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Aluno aluno = criaAluno();
                salvaAluno(aluno);
            }
        });
    }

    private void iniciaCampos() {
        nome = findViewById(R.id.activity_form_nome);
        telefone = findViewById(R.id.activity_form_tel);
        email = findViewById(R.id.activity_form_email);
    }

    private void salvaAluno(Aluno aluno) {
        dao.salva(aluno);
        //A jogada de mestre, um intent do formulario para o main
        //(onde eu estou, para onde eu vou)
        // startActivity(new Intent(FormActivity.this, MainActivity.class));
        //Contudo estavamos com problemas no fluxo, para voltar pra anterior (desempilhar):
        //Activity LifeCycle

        finish();
    }

    private Aluno criaAluno() {
        String campoNome = nome.getText().toString();
        String campoTelefone = telefone.getText().toString();
        String campoEmail = email.getText().toString();

        //Cria um novo aluno aqui mesmo

        return new Aluno(campoNome, campoTelefone, campoEmail);
    }
}
