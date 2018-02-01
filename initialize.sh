#!/bin/bash

curl -X PUT localhost:9200/texts?pretty --header "Content-Type: application/json" -d @config/config.json
curl -X POST localhost:9200/texts/text?pretty --header "Content-Type: application/json" -d @config/documents/doc.bb8.json
curl -X POST localhost:9200/texts/text?pretty --header "Content-Type: application/json" -d @config/documents/doc.milleniumfalcon.json
curl -X POST localhost:9200/texts/text?pretty --header "Content-Type: application/json" -d @config/documents/doc.tiefighter.json
