"""
API do jogo "Sem Reembolso".

Camada única que conversa com o banco MySQL. O jogo (Godot) faz requisições
HTTP em JSON para os 3 endpoints abaixo:

  GET  /api/itens        -> nomes dos itens da loja (com a "herança" do dono anterior)
  POST /api/partida      -> registra a run quando o jogador morre no Cenário 4
  GET  /api/leaderboard  -> ranking das runs, do menor tempo para o maior

Para rodar:  python app.py
A API sobe em http://localhost:5000
"""

from flask import Flask, request, jsonify
from db import get_connection

app = Flask(__name__)
# Deixa os acentos (Herói, etc.) saírem legíveis no JSON em vez de virarem ó.
app.json.ensure_ascii = False

# Mapa do código do item -> rótulo usado para montar o nome herdado.
# Ex.: BOTA + nick "João"  ->  "Bota do João"
ROTULOS = {"BOTA": "Bota", "ARMADURA": "Armadura"}


@app.route("/")
def home():
    """Rota simples só para confirmar, no navegador, que a API está no ar."""
    return jsonify({"status": "API Sem Reembolso no ar"})


# ---------------------------------------------------------------------------
# 1) GET /api/itens  -> herança dos nomes da loja
# ---------------------------------------------------------------------------
@app.route("/api/itens", methods=["GET"])
def get_itens():
    """
    Para cada item (BOTA e ARMADURA), descobre o ÚLTIMO jogador que o possuiu
    e devolve o nome já montado ("Bota do João"). Se nenhum jogador possuiu
    o item ainda, devolve o nome padrão do banco ("Bota do Herói Traído").
    """
    conexao = get_connection()
    resposta = {}
    try:
        with conexao.cursor() as cursor:
            # Pega o catálogo fixo de itens.
            cursor.execute("SELECT id_item, codigo, nome_default, preco FROM item;")
            itens = cursor.fetchall()

            for item in itens:
                # Busca o nickname da run mais recente que conteve este item.
                cursor.execute(
                    """
                    SELECT j.nickname
                    FROM run_item ri
                    JOIN run r       ON r.id_run = ri.id_run
                    JOIN jogador j   ON j.id_jogador = r.id_jogador
                    WHERE ri.id_item = %s
                    ORDER BY r.finalizada_em DESC, r.id_run DESC
                    LIMIT 1;
                    """,
                    (item["id_item"],),
                )
                dono = cursor.fetchone()  # None se ninguém possuiu o item ainda

                if dono:
                    nick = dono["nickname"]
                    nome = ROTULOS[item["codigo"]] + " do " + nick
                else:
                    nick = None
                    nome = item["nome_default"]

                resposta[item["codigo"]] = {
                    "nome": nome,
                    "dono": nick,
                    "preco": item["preco"],
                }
        return jsonify(resposta)
    except Exception as erro:
        # Se o banco falhar, devolve erro 500. O jogo trata isso usando os nomes padrão.
        return jsonify({"erro": str(erro)}), 500
    finally:
        conexao.close()


# ---------------------------------------------------------------------------
# 2) POST /api/partida  -> registra a run ao morrer no Cenário 4
# ---------------------------------------------------------------------------
@app.route("/api/partida", methods=["POST"])
def post_partida():
    """
    Recebe um JSON do jogo e grava a partida. Faz tudo numa transação:
      1. acha ou cria o jogador pelo nickname (reaproveita o id se já existir);
      2. insere a run (com o tempo) no ranking;
      3. para cada item comprado, insere uma linha em run_item (a herança).
    """
    dados = request.get_json(silent=True)
    if not dados:
        return jsonify({"erro": "Corpo da requisição não é um JSON válido"}), 400

    nickname = (dados.get("nickname") or "").strip()
    if nickname == "":
        return jsonify({"erro": "nickname é obrigatório"}), 400

    # tempo_total vem como número (pode ser float); o banco guarda inteiro.
    tempo_segundos = int(dados.get("tempo_segundos", 0))

    # Monta a lista de códigos comprados a partir das flags do jogo.
    codigos_comprados = []
    if dados.get("comprou_bota"):
        codigos_comprados.append("BOTA")
    if dados.get("comprou_armadura"):
        codigos_comprados.append("ARMADURA")

    conexao = get_connection()
    try:
        with conexao.cursor() as cursor:
            # 1) Acha o jogador; se não existir, cria.
            cursor.execute(
                "SELECT id_jogador FROM jogador WHERE nickname = %s;", (nickname,)
            )
            linha = cursor.fetchone()
            if linha:
                id_jogador = linha["id_jogador"]
            else:
                cursor.execute(
                    "INSERT INTO jogador (nickname) VALUES (%s);", (nickname,)
                )
                id_jogador = cursor.lastrowid

            # 2) Insere a run.
            cursor.execute(
                "INSERT INTO run (id_jogador, tempo_segundos) VALUES (%s, %s);",
                (id_jogador, tempo_segundos),
            )
            id_run = cursor.lastrowid

            # 3) Insere os itens possuídos (a herança).
            for codigo in codigos_comprados:
                cursor.execute(
                    "SELECT id_item FROM item WHERE codigo = %s;", (codigo,)
                )
                item = cursor.fetchone()
                if item:
                    cursor.execute(
                        "INSERT INTO run_item (id_run, id_item) VALUES (%s, %s);",
                        (id_run, item["id_item"]),
                    )

        conexao.commit()  # confirma tudo de uma vez
        return jsonify({"ok": True, "id_run": id_run, "id_jogador": id_jogador}), 201
    except Exception as erro:
        conexao.rollback()  # desfaz tudo se algo falhar no meio
        return jsonify({"erro": str(erro)}), 500
    finally:
        conexao.close()


# ---------------------------------------------------------------------------
# 3) GET /api/leaderboard  -> ranking por tempo
# ---------------------------------------------------------------------------
@app.route("/api/leaderboard", methods=["GET"])
def get_leaderboard():
    """Lista as runs ordenadas do menor tempo para o maior."""
    conexao = get_connection()
    try:
        with conexao.cursor() as cursor:
            cursor.execute(
                """
                SELECT j.nickname, r.tempo_segundos
                FROM run r
                JOIN jogador j ON j.id_jogador = r.id_jogador
                ORDER BY r.tempo_segundos ASC, r.finalizada_em ASC
                LIMIT 50;
                """
            )
            ranking = cursor.fetchall()
        return jsonify({"leaderboard": ranking})
    except Exception as erro:
        return jsonify({"erro": str(erro)}), 500
    finally:
        conexao.close()


if __name__ == "__main__":
    # debug=True reinicia sozinho quando você edita o arquivo (bom pra desenvolver).
    app.run(host="0.0.0.0", port=5000, debug=True)
