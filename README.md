<h1 align="center"> No Refunds </h1>
<p align="center">
<!-- <img width="527" height="527" alt="NoRefundsLogo" src="https://github.com/user-attachments/assets/placeholder-image" /> </p> -->
<!-- <hr> -->
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

<b>Mecânicas Principais:</b>
- **Ciclo de Progressão:** O jogador coleta moedas derrotando inimigos comuns no 'CENÁRIO 2' para comprar os itens na loja. No penúltimo cenário o Herói poderá enfrentar o Chefe e finalmente o derrotar. Após digitar seu nome, o jogador deve continuar para o 'CENÁRIO 4'. Neste último local, o Mercador irá trair o personagem, matando-o, furtando seus itens e finalizando o jogo.
- **Sistema de Loja e Buffs:** O lojista recomendará o Herói a comprar os itens 'ARMADURA' e 'BOTA'. O primeiro dobrará a vida do personagem e o segundo aumentará a distância do pulo do personagem.
- **Backtracking e Evolução de Dificuldade:** Após a compra na loja, o personagem retornará ao segundo cenário, porém este irá receber uma atualização visual e comportamental (além dos inimigos anteriores aparecerem novamente, aparecerão novos inimigos voadores). Todos estes inimigos agora serão impossíveis de serem derrotados, cabendo ao jogador desviar deles.
- **Sistema de Herança Assíncrono:** Caso o jogador ou outra pessoa iniciar uma nova tentativa, os nomes dos dois itens na loja do Mercador poderão receber o nome do jogador anterior (Exemplo: Bota do João, Armadura do João).
- **Leaderboard Global:** O jogo conta com um leaderboard no menu principal, ranqueando as partidas dos jogadores conforme o tempo de conclusão.

<hr>

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

Documento do Projeto (em andamento): [Projeto_BRAAOOB.pdf](https://github.com/user-attachments/files/28857847/Projeto_BRAAOOB.pdf)
