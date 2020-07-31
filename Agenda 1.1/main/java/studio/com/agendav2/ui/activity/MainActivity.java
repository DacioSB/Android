package studio.com.agendav2.ui.activity;

import android.content.Intent;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.List;

import studio.com.agendav2.DAO.AlunoDAO;
import studio.com.agendav2.R;
import studio.com.agendav2.model.Aluno;

public class MainActivity extends AppCompatActivity {

    public static final String CHAVE_ALUNO = "aluno";
    protected static final AlunoDAO dao = new AlunoDAO();
    private static final String TAG = "MAIN";
    private ArrayAdapter<Aluno> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Setando titulo

        setTitle("Lista de Alunos");
        //Log.d(TAG,"iniciou botao FAB");
        botaoFAB();
        //So precisa configurar a lista uma vez entao deixa no oncreate() e nao no onresume()
        configuraLista();



    }
    //Permite a criaçao de menus de contexto (avisos)
    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
        super.onCreateContextMenu(menu, v, menuInfo);
        getMenuInflater().inflate(R.menu.mainactivity_menu, menu);
    }

    //ContextMenu especifico para pegar adapterview. Pega o item, e remove ele
    @Override
    public boolean onContextItemSelected(MenuItem item) {

        int itemId = item.getItemId();
        if(itemId == R.id.remove_item){
            AdapterView.AdapterContextMenuInfo menuInfo = (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();
            Aluno alunoEscolhido = adapter.getItem(menuInfo.position);
            removeAluno(alunoEscolhido);
        }
        return super.onContextItemSelected(item);
    }

    private void botaoFAB() {
        //Organizar o fluxo do FAB

        FloatingActionButton botaoAdd = findViewById(R.id.fab_add_aluno);
        botaoAdd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                abreFormAlunoInserirNovo();
            }
        });
    }

    private void abreFormAlunoInserirNovo() {
        startActivity(new Intent(this, FormActivity.class));
    }

    @Override
    protected void onResume() {
        super.onResume();
        atualizaAlunos();

    }

    private void atualizaAlunos() {
        //Adapter limpa aew
        adapter.clear();
        //Adapter pega tudo de volta aew atualizados
        adapter.addAll(dao.devolveAlunos());
    }

    private void configuraLista() {
        ListView listaAlunos = findViewById(R.id.listinha);

        configuraAdapter(listaAlunos);
        //Listener para quando clicar, editar
        //Contudo, alunos pode "ConfigListenerCliqueItem(listaAlunos, alunos);"referenciar pra outra lista que nao seja da listview
        configListenerCliqueItem(listaAlunos);

       // configListenerCliqueLongoItem(listaAlunos);
        registerForContextMenu(listaAlunos);
    }

//    private void configListenerCliqueLongoItem(ListView listaAlunos) {
//        listaAlunos.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
//            @Override
//            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
//                Log.d(TAG, "clique longo" + " - " + position);
//                //Deixa em true pra consumir o longo clique e nao seguir para o clique
//                Aluno alunoEscolhido = (Aluno)parent.getItemAtPosition(position);
//                removeAluno(alunoEscolhido);
//                return false;
//            }
//        });
//    }

    private void removeAluno(Aluno alunoEscolhido) {
        dao.remove(alunoEscolhido);
        adapter.remove(alunoEscolhido);
    }

    private void configListenerCliqueItem(ListView listaAlunos) {
        listaAlunos.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                //Estava alunos.get(position)... Dessa forma aqui é mais seguro
                Aluno alunoEscolhido = (Aluno)parent.getItemAtPosition(position);
                abreFormularioModoEditar(alunoEscolhido);
            }
        });
    }

    private void abreFormularioModoEditar(Aluno alunoEscolhido) {
        Intent vaiParaFormulario = new Intent(MainActivity.this, FormActivity.class);
        //Transferir dados primitivos e objects mas a classe aluno precisa ser serializada
        vaiParaFormulario.putExtra(CHAVE_ALUNO, alunoEscolhido);
        startActivity(vaiParaFormulario);
    }

    private void configuraAdapter(ListView listaAlunos) {
        adapter = new ArrayAdapter<>(this, android.R.layout.simple_expandable_list_item_1);
        listaAlunos.setAdapter(adapter);
    }
}
