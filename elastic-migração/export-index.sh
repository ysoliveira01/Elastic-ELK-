#!/bin/bash

# Endereço do Elasticsearch de origem e destino
ELASTICSEARCH_SOURCE="20.106.82.18:9200"
ELASTICSEARCH_DEST="172.214.1.192:9200"

# Credenciais do Elasticsearch de origem e destino
SOURCE_USERNAME="cli"
SOURCE_PASSWORD="@Timao1991"
DEST_USERNAME="elastic"
DEST_PASSWORD="1gK2TAD57vGtb80s1vQBT478"

# Lista todos os índices
echo "Listando todos os índices no Elasticsearch de origem..."
indices=$(curl -s -k -X GET -u "$SOURCE_USERNAME:$SOURCE_PASSWORD" "$ELASTICSEARCH_SOURCE/_cat/indices?v&h=index" | awk '{print $NF}' | tr -d ' ')

# Itera sobre cada índice e exporta/importa dados e mapeamento
for index in $indices; do
    echo "------------------------"
    echo "Processando índice: $index"

    # Exportar mapeamento
    echo "Exportando mapeamento do índice: $index"
    elasticdump --input="$SOURCE_USERNAME:$SOURCE_PASSWORD@$ELASTICSEARCH_SOURCE/$index" --output="$DEST_USERNAME:$DEST_PASSWORD@$ELASTICSEARCH_DEST/$index" --type=mapping --quiet
    echo "Mapeamento do índice $index exportado com sucesso!"

    # Exportar e importar dados
    echo "Exportando dados do índice: $index"
    elasticdump --input=https://"$SOURCE_USERNAME:$SOURCE_PASSWORD@$ELASTICSEARCH_SOURCE/$index" --output=https://"$DEST_USERNAME:$DEST_PASSWORD@$ELASTICSEARCH_DEST/$index" --type=data --limit=10000 --quiet
    echo "Dados do índice $index exportados e importados com sucesso!"
done

echo "Todos os índices foram processados com sucesso!"
