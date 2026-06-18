<h1 align="center"> Sem Reembolso </h1>
<p align="center">
<p align="center">
  <img src="AssetsParaEditarREADME/gifSemReembolso.gif" alt="Tela" width="700"/>
</p>
<h3>Integrantes</h3>

• João Pedro Piniani <a href="https://github.com/jppiniani">
  <img src="https://img.shields.io/badge/github-logo=github" />
  </a>
  <a href="https://www.linkedin.com/in/jppiniani/">
  <img src="https://img.shields.io/badge/linkedin-0A66C2?style=flat&logo=linkedin&logoColor=white" />
  </a>
  
• Nicolas Belisário <a href="https://github.com/nicolasbelisario">
  <img src="https://img.shields.io/badge/github-logo=github" />
  </a>
  <a href="https://www.linkedin.com/in/nicolas-belisario-alves/">
  <img src="https://img.shields.io/badge/linkedin-0A66C2?style=flat&logo=linkedin&logoColor=white" />
  </a>

• Lucas Cavalcante <a href="https://github.com/cavalcante-l">
  <img src="https://img.shields.io/badge/github-logo=github" />
  </a>
  <a href="https://www.linkedin.com/in/lucas-cavalcante-barbosa-924b4835b/">
  <img src="https://img.shields.io/badge/linkedin-0A66C2?style=flat&logo=linkedin&logoColor=white" />
  </a>

• Pedro Rodrigues <a href="https://github.com/PedroRodrigues2508">
  <img src="https://img.shields.io/badge/github-logo=github" />
  </a>
  <a href="https://www.linkedin.com/in/pedro-rodrigues-a698ab2a5/">
  <img src="https://img.shields.io/badge/linkedin-0A66C2?style=flat&logo=linkedin&logoColor=white" />
  </a>

• Gabriela Perdigão <a href="https://github.com/gabriela-perdigao">
  <img src="https://img.shields.io/badge/github-logo=github" />
  </a>
  <a href="https://www.linkedin.com/in/gabriela-perdig%C3%A3o-da-silva-094058262/">
  <img src="https://img.shields.io/badge/linkedin-0A66C2?style=flat&logo=linkedin&logoColor=white" />
  </a>

<hr>

<h3>Objetivo Geral</h3>

O objetivo geral deste projeto é desenvolver um jogo de plataforma 2D utilizando a engine Godot 4.6, integrado a um banco de dados relacional via API, para a disciplina de Análise Orientada a Objetos (AOO). O projeto visa demonstrar a aplicação prática de conceitos de programação orientada a objetos na estruturação das entidades do jogo (herói, inimigos, itens, mercador) além de construir uma conexão sólida e simples entre Front-End (Godot), Back-End (API em Python) e Banco de Dados (MySQL).

<hr>

<h3>Sobre o Jogo</h3>
'Sem Reembolso' é um jogo de plataforma onde um herói recém-chegado a um novo local é manipulado por um NPC (Mercador) para realizar a tarefa de destruir um inimigo específico (Chefe) e obter uma recompensa. No final da partida, o jogador é morto pelo Mercador e os itens comprados por ele durante a jornada são revendidos a um próximo jogador em uma nova tentativa. O jogo recebeu esse nome visto que se trata de uma compra "infeliz" do Herói.
<br>
<b>Mecânicas Principais:</b>

- **Ciclo de Progressão:** O jogador coleta moedas derrotando inimigos comuns no 'CENÁRIO 2' para comprar os itens na loja. No penúltimo cenário o Herói poderá enfrentar o Chefe e finalmente o derrotar. Após digitar seu nome, o jogador deve continuar para o 'CENÁRIO 4'. Neste último local, o Mercador irá trair o personagem, matando-o, furtando seus itens e finalizando o jogo.
  
- **Sistema de Loja e Buffs:** O lojista recomendará o Herói a comprar os itens 'ARMADURA' e 'BOTA'. O primeiro dobrará a vida do personagem e o segundo aumentará a distância do pulo do personagem.
  
- **Backtracking e Evolução de Dificuldade:** Após a compra na loja, o personagem retornará ao segundo cenário, porém este irá receber uma atualização visual e comportamental (além dos inimigos anteriores aparecerem novamente, aparecerão novos inimigos voadores). Todos estes inimigos agora serão impossíveis de serem derrotados, cabendo ao jogador desviar deles.
  
- **Sistema de Herança Assíncrono:** Caso o jogador ou outra pessoa iniciar uma nova tentativa, os nomes dos dois itens na loja do Mercador poderão receber o nome do jogador anterior (Exemplo: Bota do João, Armadura do João).
  
- **Leaderboard Global:** O jogo conta com um leaderboard no menu principal, ranqueando as partidas dos jogadores conforme o tempo de conclusão.


<b>Lógica Banco de Dados e API:</b>
  <br>
  <p align="center">
  <img src="AssetsParaEditarREADME/der.png" alt="Tela" width="700"/>
</p>
<br>
<br>
A comunicação segue uma arquitetura cliente-servidor: o jogo (Godot) atua como
cliente e conversa com uma <b>API em Python (Flask)</b>, que por sua vez é a única
camada que acessa o banco <b>MySQL</b>. Toda a troca de dados é feita em formato
<b>JSON</b>, mantendo o front-end desacoplado da persistência.

O banco é composto por quatro tabelas:

- <b>JOGADOR</b> — guarda o jogador, identificado por um <code>nickname</code> único.
- <b>RUN</b> — cada partida concluída, com o <code>tempo</code> de conclusão (usado no ranking).
- <b>ITEM</b> — catálogo fixo dos equipamentos (Bota e Armadura), com nome padrão e preço.
- <b>ITEM_has_RUN</b> — tabela associativa (N:N) que registra quais itens pertenceram a quais runs.

A lógica do jogo gira em torno de dois momentos de comunicação com a API:

<b>1. Início da partida (leitura / GET):</b> ao abrir a loja, o jogo pergunta à API
quais são os nomes atuais dos itens. O "nome do dono" <b>não é um campo armazenado</b>:
ele é derivado por uma junção <code>ITEM → ITEM_has_RUN → RUN → JOGADOR</code>, buscando
o último jogador que possuiu aquele item. Se não houver dono anterior, usa-se o nome
padrão (ex.: "Bota do Cavaleiro Traído").

<b>2. Fim da partida (escrita / POST):</b> quando o Mercador mata o Herói no Cenário 4,
o jogo envia um <b>único POST</b> com o nickname, o tempo e os itens possuídos. A API então:
busca ou cria o jogador pelo nickname (reaproveitando o ID se já existir); insere a nova
RUN no ranking; e, havendo itens, insere os registros em ITEM_has_RUN — efetivando a herança.

É exatamente essa herança que dá nome ao jogo: na próxima tentativa, a consulta do passo 1
encontrará o dono anterior e a loja exibirá "Bota do João", "Armadura do João" e assim por diante.
O <b>leaderboard</b> do menu principal usa uma terceira consulta (GET), listando as runs
ordenadas pelo menor tempo.

<br>
<p align="center">
  <img src="AssetsParaEditarREADME/fluxo.png" alt="Tela" width="700"/>
</p>
<hr>
<br>

<b>Diagrama de Classes de Domínio</b>
```mermaid
classDiagram
    class Heroi {
        -int vida
        -int moedas
        -float alturaPulo
        +mover()
        +atacar(Inimigo)
        +coletarMoeda(Moeda)
        +comprarItem(Item)
    }
    class Mercador {
        -bool primeiraInteracao
        +venderItem(Item)
        +eliminarHeroi(Heroi)
    }
    class Loja {
        +exibirItens()
    }
    class Item {
        <<abstract>>
        -string nome
        -int custo
        +aplicarEfeito(Heroi)
    }
    class Armadura {
        +aplicarEfeito(Heroi)
    }
    class Bota {
        +aplicarEfeito(Heroi)
    }
    class Inimigo {
        <<abstract>>
        -bool imortal
        -int acertosNecessarios
    }
    class InimigoComum {
        +droparMoeda() Moeda
    }
    class InimigoVoador {
        +voar()
    }
    class Chefe {
        +receberDano()
    }
    class Moeda {
        -int valor
    }

    Item <|-- Armadura
    Item <|-- Bota
    Inimigo <|-- InimigoComum
    Inimigo <|-- InimigoVoador
    Inimigo <|-- Chefe

    Mercador "1" --> "1" Loja : opera
    Loja "1" o-- "2" Item : oferece
    Heroi "1" --> "0..2" Item : compra
    Heroi "1" --> "0..*" Moeda : coleta
    Heroi "1" --> "1..*" Inimigo : enfrenta
    Mercador "1" --> "1" Heroi : elimina
    InimigoComum "1" --> "0..1" Moeda : dropa
```
<br>
<h3>Ferramentas e tecnologias utilizadas</h3>

- **Front-End / Engine:** Utilização da engine Godot 4.6. O Godot possui uma vasta gama de ferramentas nativas e uma interface visual que facilita a manipulação do sistema de Cenas e Nós, tornando a aplicação de conceitos de POO organizada e intuitiva.
- **Artes Visuais:** O software LibreSprite foi utilizado para criar e animar sprites (imagens bidimensionais 2D).
- **Back-End (API):** Python (Flask) para a comunicação do jogo com o banco.
- **Banco de Dados:** Armazenamento em SGBD Relacional (MySQL).
- **Versionamento:** Git e GitHub.

<p align="center">
  <img width="30" height="30" alt="Godot" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/godot/godot-original.svg" />
  <img width="30" height="30" alt="Python" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" />
  <img width="30" height="30" alt="MySQL" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg" />
</p>

<hr>
<!-- (Aqui eu vou mudar pro PDF atualizado) -->
<h3>Documentação</h3>

Documento do Projeto (em andamento): [PDF do Projeto](https://github.com/user-attachments/files/29115666/pdf.pdf)


