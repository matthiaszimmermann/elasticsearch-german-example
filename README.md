# Elasticsearch Example Usage for German Language

This repo walks you through download, installation and usage for German text retrieval.
It contains all necessary ingredients to build a custom German analyzer including stopping, stemming and working with synonyms.

## Download, Install and run Elasticsearch

Start with cloning this repo. Then, build the custom Docker image including Elasticsearch and some example configuration and data files. The custom image is directly based on the original Elasticsearch Dockerfile setup described [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html).

```
docker build . --tag "elasticsearch.custom:latest"
```

The image can now be used to run a corresponding container. Once the container is running run the initialization script that configures the elasticsearch instance to deal with German text and adds some sample documents.

```
docker run -d -p 9200:9200 elasticsearch.custom
docker exec <container-id> bash initialize.sh
```

The container id can be obtained by checking the hash provided by ```docker ps```. Your Elasticsearch instance should now be up and running on port 9200.

## Verify the running Elasticsearch

To verify the correct running of your container you may check the respones by any of the following urls.

* http://localhost:9200/

If you get some valid json respones without any error messages you should be good to go. Now let's check what sample documents we have in our index (in the example our elasticsearch index is named 'texts'

* http://localhost:9200/texts/text/_search?pretty

You may add additional documents via command line to the index based on the example below.

```
curl -X POST localhost:9200/texts/text?pretty --header "Content-Type: application/json" -d '
{
  "title" : "75194 First Order TIE Fighter™ Microfighter",
  "body" : "Stell mit dem superschnellen First Order TIE Fighter Microfighter dem Widerstand nach! Setz den Piloten oben auf, lade die Raketen und stürz dich ins Gefecht!",
  "created" : "2018-02-01 11:02:35"
}
'
```

## Checking the Text Processing Pipeline

Many aspects of the Elasticsearch text processing pipeline are described [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis.html).

For the definition of the custom German analyzer and its usage for the indexing check the following links

* http://localhost:9200/texts/_settings?pretty
* http://localhost:9200/texts/_mappings?pretty

The [settings](http://localhost:9200/texts/_settings?pretty) link shows the definition of our custom analyzer ```custom_german_analyzer``` (see file ```synonym.txt``` in this repository for . referenced synonyms).

The [mappings](http://localhost:9200/texts/_mappings?pretty) link defines which document attributes will analyzed by which  analyzers. In this example field ```title``` is analyzed using the standard (default) analyizer while the additionally defined field ```title.german``` is analyzed with our custom German analyzer ```custom_german_analyzer```.

## Check the output of the German Custom Analyzer

To check how the specified analyzer works with provided text you may use the analyze end point of the [Indices API](https://www.elastic.co/guide/en/elasticsearch/reference/6.1/indices-analyze.html).

```
curl -XGET 'localhost:9200/texts/_analyze?pretty' -H 'Content-Type: application/json' -d'
{
  "analyzer" : "custom_german_analyzer",
  "text" : "Die Millennium Falcon Milleniumfalcon fliegen schneller als BB8 bb-8 bb 8 Droiden"
}
'
```

## Text Retrieval Examples

Search matching documents in the index using the sentence "Lego ist cool". For the search the fields title.german and body.german are used.

```
curl -X GET localhost:9200/_search?pretty  -H 'Content-Type: application/json' -d'
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
```

Search for "BB-8"

```
curl -X GET localhost:9200/_search?pretty  -H 'Content-Type: application/json' -d'
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
```

Search for sentence "Legos mit dem MillenniumFalcon sind cooler als solche mit Tie Fighters"

```
curl -X GET localhost:9200/_search?pretty  -H 'Content-Type: application/json' -d'
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
```

