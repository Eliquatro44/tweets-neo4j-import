// 4. Criando nós de Tweet original (sem referência)
WITH tweet
WHERE NOT EXISTS(tweet.referenced_tweets)
MERGE (t:Tweet {id: tweet.id})
ON CREATE SET 
    t.text = tweet.text,
    t.created_at = tweet.created_at,
    t.author_id = tweet.author_id,
    t.tipo = 'original';

// 5. Filtra apenas os tweets com referência a outros tweets
WITH tweet
WHERE EXISTS(tweet.referenced_tweets)
UNWIND tweet.referenced_tweets AS ref
WITH tweet, ref

//  6. Cria ou encontra o nó do tweet atual 'current' e do tweet referenciado 'referenced'.
MERGE (current:Tweet {id: tweet.id})
ON CREATE SET 
    current.text = tweet.text,
    current.created_at = tweet.created_at,
    current.author_id = tweet.author_id,
    current.tipo_ref = ref.type


MERGE (referenced:Tweet {id: ref.id})

// Armazenando o tipo de referência (retweeted, quoted, replied_to)


// 7 . Usa FOREACH como alternativa ao IF aplicando lógica condicional:
//Se for retweeted: cria relacionamento RETWEETED, troca label para Retweet.
// Como no exemplo final da aula prática:
// Se for quoted: cria QUOTED, troca label para Quoted.
//Se for replied_to: cria REPLIED_TO, troca label para Reply.
// Remove a label genérica Tweet para refletir o tipo específico.


WITH current, referenced, ref
FOREACH (ignore IN CASE WHEN ref.type = 'retweeted' THEN [1] ELSE [] END |
    MERGE (current)-[:RETWEETED]->(referenced)
    SET current:Retweet
    REMOVE current:Tweet
)
FOREACH (ignore IN CASE WHEN ref.type = 'quoted' THEN [1] ELSE [] END |
    MERGE (current)-[:QUOTED]->(referenced)
    SET current:Quoted
    REMOVE current:Tweet
)
FOREACH (ignore IN CASE WHEN ref.type = 'replied_to' THEN [1] ELSE [] END |
    MERGE (current)-[:REPLIED_TO]->(referenced)
    SET current:Reply
    REMOVE current:Tweet
);