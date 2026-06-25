# build/

Esta pasta guarda o **executável exportado do jogo** (`SemReembolso.exe`), para
quem quiser jogar **sem instalar o Godot**.

## Como jogar (usuário final)

1. Tenha o **MySQL** rodando e o banco importado (`backend/schema.sql`).
2. Suba a **API**: `cd backend && python app.py` (veja o README principal).
3. Dê duplo-clique em **`SemReembolso.exe`**.

> O jogo procura a API em `http://127.0.0.1:5000`. Sem MySQL + API no ar, a loja
> mostra os nomes padrão e o leaderboard não carrega.

## Como gerar/atualizar o executável (mantenedor, precisa do Godot 4.6)

1. Primeira vez: **Editor → Manage Export Templates → Download and Install**.
2. **Project → Export → Add… → Windows Desktop**.
3. Marque **"Embed PCK"** (gera um único `.exe`, mais fácil de distribuir).
4. Caminho de saída: `build/SemReembolso.exe` → **Export Project**.
5. Commit o `.exe` (já vai via Git LFS, configurado no `.gitattributes`).
