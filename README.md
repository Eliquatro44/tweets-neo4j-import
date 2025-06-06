# tweets-neo4j-import

# Importação de Tweets no Neo4j (com APOC + JSON)

Este projeto demonstra a importação e modelagem de uma rede de tweets no Neo4j, utilizando arquivos JSON e a biblioteca APOC.

## 🧩 Tecnologias

- Neo4j
- Cypher
- APOC (procedimentos auxiliares)
- JSON

## 📁 Estrutura

- `data/tweets.json` — Arquivo com os tweets (originais, retweets, respostas e citações)
- `cypher/import.cypher` — Script para importar o JSON
- `cypher/model.cypher` — Script para modelar os dados no grafo

## ▶️ Execução

1. Instale o **Neo4j Desktop** ou use o **Neo4j Aura** (cloud).
2. Certifique-se de que o plugin **APOC** está habilitado.
3. Copie o arquivo `tweets.json` para dentro da pasta `import/` do Neo4j.
4. Execute os scripts `.cypher` no browser do Neo4j ou via Neo4j Desktop.

## 📌 Exemplo de importação

```cypher
CALL apoc.load.json("file:///tweets.json") YIELD value
MERGE (u:User {id: value.user.id})
MERGE (t:Tweet {id: value.id, text: value.text})
MERGE (u)-[:POSTED]->(t)
