docker build . --tag "elasticsearch.custom:latest"
docker run -d -p 9200:9200 elasticsearch.custom

docker exec <container-id> bash initialize.sh

# check setup
curl -X GET localhost:9200/
curl -X GET localhost:9200/texts/_settings?pretty
curl -X GET localhost:9200/texts/_mappings?pretty

# check sample docs
curl -X GET localhost:9200/texts/text/_search?pretty

# check text normalization pipeline
curl -XGET 'localhost:9200/texts/_analyze?pretty' -H 'Content-Type: application/json' -d'
{
  "analyzer" : "custom_german_analyzer",
  "text" : "Die Millennium Falcon Milleniumfalcon fliegen schneller als BB8 bb-8 bb 8 Droiden"
}
'

# text retrieval for "lego"
curl -XGET localhost:9200/_search?pretty  -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "type":     "most_fields",
      "query":    "Lego ist cool",
      "fields":   ["title.german", "body.german" ]
    }
  }
}
'

# text retrieval for "bb-8"
curl -XGET localhost:9200/_search?pretty  -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "type":     "most_fields",
      "query":    "Ein Lego mit BB-8",
      "fields":   ["title.german", "body.german" ]
    }
  }
}
'

# text retrieval for "millennium falcon and tie fighter"
curl -XGET localhost:9200/_search?pretty  -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "type":     "most_fields",
      "query":    "Legos mit dem MillenniumFalcon sind cooler als solche mit Tie Fighters",
      "fields":   ["title.german", "body.german" ]
    }
  }
}
'
