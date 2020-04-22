package studio.com.agendav2.ui.activity;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;


import java.io.Serializable;

import studio.com.agendav2.DAO.AlunoDAO;
import studio.com.agendav2.R;
import studio.com.agendav2.model.Aluno;

public class FormActivity extends AppCompatActivity {

    public static final String CHAVE_ALUNO = "aluno";
    private EditText nome;
    private EditText telefone;
    private EditText email;
    private final AlunoDAO dao = new AlunoDAO();
    private Aluno aluno = new Aluno();
    private static String TAG = "form";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form);



        //Vai criar uma classe DAO para comportar toda informação que passaremos para as outras entidades do problema

        /*Preenchimento campos
        Ele deixou como final porque as variaveis estao sendo utilizadas como variaveis globais
        la no metodo onClick*/
        iniciaCampos();
        //Botao salvar
        carregaAluno();

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.form_aluno_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
        if(itemId == R.id.form_activity_salvar_aluno){
            finaliza();
        }

        return super.onOptionsItemSelected(item);
    }

    private void carregaAluno() {
        Intent dados = getIntent();
        //Pega o serializable la do main activity, na transferencia de dados, recebe aqui
        //E foi necessario fazer um cast pra o tipo aluno
        if(dados.hasExtra(CHAVE_ALUNO)){
            setTitle("Edita Aluno");
            this.aluno = (Aluno) dados.getSerializableExtra(CHAVE_ALUNO);
            preencheCampos();
        } else{
            setTitle("Novo Aluno");
            aluno = new Aluno();
        }
    }

    private void preencheCampos() {
        nome.setText(aluno.getCampoNome());
        telefone.setText(aluno.getCampoTelefone());
        email.setText(aluno.getCampoEmail());
    }

    private void finaliza() {
        //                Aluno aluno = criaAluno();
//                salvaAluno(aluno);
        criaAluno();
        if(aluno.IdValido()){
            dao.edita(aluno);
        }else{
            dao.salva(aluno);
            Log.d(TAG, "iniciou - " + dao.devolveAlunos() + " - " + MainActivity.dao.devolveAlunos());
        }

        finish();

    }

    private void iniciaCampos() {
        nome = findViewById(R.id.activity_form_nome);
        telefone = findViewById(R.id.activity_form_tel);
        email = findViewById(R.id.activity_form_email);

    }



    private void criaAluno() {
        String campoNome = nome.getText().toString();
        String campoTelefone = telefone.getText().toString();
        String campoEmail = email.getText().toString();



        aluno.setCampoNome(campoNome);
        aluno.setCampoEmail(campoEmail);
        aluno.setCampoTelefone(campoTelefone);
    }
}
