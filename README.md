# FluentPath

Área do aluno de uma escola de idiomas, feita em Flutter para a Avaliação I de Programação Móvel (IFBA).

O app tem duas áreas:

- **Pública:** qualquer pessoa lê as dicas de inglês, sem login.
- **Do aluno:** depois do login, o aluno vê as aulas, agenda novas, confirma presença e cancela.

## Como rodar

### Pré-requisitos

- Flutter 3.x instalado (`flutter doctor` sem erros)
- Um emulador Android, um celular conectado ou o Chrome

### Passos

```bash
flutter pub get
flutter run
```

### Login de demonstração

| Usuário | Senha |
| --- | --- |
| `aluno` | `1234` |

### Testes

```bash
flutter test
```

## O que foi feito

| # | Funcionalidade | Onde |
| --- | --- | --- |
| 1 | Tema com as cores do app e navegação por rotas nomeadas | `lib/main.dart`, `lib/rotas.dart` |
| 2 | Modelos `Dica`, `Aula` e `Usuario` com `fromJson` (e `toJson` em `Aula`) | `lib/models/` |
| 3 | Dados estáticos em JSON | `assets/data/dicas.json`, `assets/data/aulas.json` |
| 4 | Serviço único de dados e sessão: lê os JSON, guarda o usuário logado e as aulas | `lib/data/servico_dados.dart` |
| 5 | Listagem pública de dicas, sem login | `lib/screens/tela_dicas.dart` |
| 6 | Detalhe da dica com conteúdo formatado (negrito, sublinhado, seções e listas) | `lib/screens/tela_detalhe_dica.dart`, `lib/widgets/conteudo_formatado.dart` |
| 7 | Login mockado (`aluno` / `1234`), com aviso para credencial errada | `lib/screens/tela_login.dart` |
| 8 | Página de boas-vindas após o login, com atalhos para Dicas e Minhas aulas | `lib/screens/tela_boas_vindas.dart` |
| 9 | Minhas aulas: lista, confirmar presença e cancelar aula | `lib/screens/tela_minhas_aulas.dart` |
| 10 | Agendar aula: tema, dia e horário (calendário em português) | `lib/screens/tela_agendar_aula.dart` |
| 11 | Persistência das aulas com `shared_preferences`: continuam salvas após sair e ao fechar o app | `lib/data/servico_dados.dart` |
| 12 | Logoff e proteção das telas do aluno: sem login, elas mostram um bloqueio | `lib/widgets/botao_sair.dart`, `lib/widgets/acesso_protegido.dart` |
| 13 | Testes de modelos, serviço, formatação e fluxos de tela | `test/` |

## Arquitetura

```text
lib/
  main.dart        raiz do app, tema e idioma
  rotas.dart       nomes das rotas e quais telas são protegidas
  models/          Dica, Aula, Usuario
  data/            ServicoDados: JSON, sessão e persistência
  screens/         telas
  widgets/         componentes reutilizáveis (cards, botão sair, acesso protegido)
assets/
  data/            dicas.json e aulas.json
```

As telas não leem JSON direto: elas pedem os dados ao `ServicoDados`, que é compartilhado com o pacote `provider`. Quando a sessão ou as aulas mudam, o serviço avisa as telas, e elas se atualizam sozinhas.

O `aulas.json` é o ponto de partida. Na primeira alteração (agendar, confirmar ou cancelar), a lista passa a ser salva no aparelho com `shared_preferences`, porque os arquivos de `assets/` são só leitura.

### Formatação das dicas

O campo `conteudo` do `dicas.json` aceita uma marcação simples:

| Marcação | Resultado |
| --- | --- |
| `**texto**` | negrito |
| `__texto__` | sublinhado |
| `# Título` no início da linha | título de seção |
| `- item` no início da linha | item de lista |

## Fluxo para demonstração

1. Abrir o app: a lista de dicas aparece sem login.
2. Tocar numa dica para ver o conteúdo formatado.
3. Tocar no ícone de entrar e errar a senha: aparece um aviso.
4. Entrar com `aluno` / `1234`: abre a página de boas-vindas.
5. Ir em **Minhas aulas**: confirmar a presença numa aula e cancelar outra.
6. Tocar em **Agendar aula**, escolher tema, dia e horário e agendar.
7. Tocar em **Sair**: o app volta às dicas, deslogado.
8. Entrar de novo: as mudanças nas aulas continuam lá.

Para recomeçar com as aulas originais do `aulas.json`, desinstale o app do aparelho.
