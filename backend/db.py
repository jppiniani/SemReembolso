"""
Conexão com o banco MySQL.

Este módulo concentra TODA a lógica de conectar no banco. Os outros arquivos
(app.py) chamam get_connection() e nem precisam saber a senha - ela vem do .env.
"""

import os
import pymysql
from dotenv import load_dotenv

# Lê o arquivo .env e carrega as variáveis (DB_HOST, DB_USER, etc.) para o ambiente.
load_dotenv()


def get_connection():
    """Abre e devolve uma nova conexão com o banco game_lambda."""
    return pymysql.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME", "game_lambda"),
        charset="utf8mb4",
        # DictCursor faz cada linha vir como dicionário {coluna: valor},
        # o que facilita transformar em JSON depois.
        cursorclass=pymysql.cursors.DictCursor,
    )


# Bloco de teste: roda SÓ quando você executa "python db.py" diretamente.
# Serve para conferir, de forma isolada, se a conexão e o .env estão corretos.
if __name__ == "__main__":
    try:
        conexao = get_connection()
        with conexao.cursor() as cursor:
            cursor.execute("SELECT * FROM item;")
            for linha in cursor.fetchall():
                print(linha)
        conexao.close()
        print("\nConexao com o banco OK!")
    except Exception as erro:
        print("FALHOU ao conectar:", erro)
