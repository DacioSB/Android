package studio.com.agendav2.model;

import android.support.annotation.NonNull;

public class Aluno {
    private final String campoNome;
    private final String campoTelefone;
    private final String campoEmail;

    public Aluno(String campoNome, String campoTelefone, String campoEmail) {

        this.campoNome = campoNome;
        this.campoTelefone = campoTelefone;
        this.campoEmail = campoEmail;
    }

    @NonNull
    @Override
    public String toString() {
        return this.campoNome;
    }
}
