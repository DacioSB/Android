package studio.com.agendav2.model;

import android.support.annotation.NonNull;

import java.io.Serializable;

public class Aluno implements Serializable {


    private int id;
    private String campoNome;
    private String campoTelefone;
    private String campoEmail;

    public Aluno(String campoNome, String campoTelefone, String campoEmail) {
        this.id = 0;
        this.campoNome = campoNome;
        this.campoTelefone = campoTelefone;
        this.campoEmail = campoEmail;
    }
    public Aluno(){

    }
    public String getCampoNome() {
        return campoNome;
    }

    public String getCampoTelefone() {
        return campoTelefone;
    }

    public String getCampoEmail() {
        return campoEmail;
    }
    @NonNull
    @Override
    public String toString() {
        return this.campoNome;
    }

    public void setId(int contadorId) {
        this.id = contadorId;
    }

    public int getId() {
        return this.id;
    }

    public void setCampoNome(String campoNome) {
        this.campoNome = campoNome;
    }

    public void setCampoTelefone(String campoTelefone) {
        this.campoTelefone = campoTelefone;
    }

    public void setCampoEmail(String campoEmail) {
        this.campoEmail = campoEmail;
    }

    public boolean IdValido() {
        return id > 0;
    }
}
