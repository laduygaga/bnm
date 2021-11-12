#!/bin/bash
get_connector() {
    curl -X GET "http://bnm:8083/connectors"
}
create_mongo_source() {
    curl -iX POST "http://bnm:8083/connectors" \
    -H "Content-Type: application/json" \
    -d '{
       "name": "mongo-source",
       "config": {
         "name": "mongo-source",
          "connector.class": "io.debezium.connector.mongodb.MongoDbConnector",
          "mongodb.name": "mongodb",
          "mongodb.hosts": "rs0/mongo1,mongo2,mongo3:27017",
          "mongodb.user": "duy",
          "mongodb.password": "123",
          "tasks.max": "1",
          "database.history.kafka.bootstrap.servers": "kafka:9092",
          "database.history.kafka.topic": "schema-changes.test",
          "internal.key.converter": "org.apache.kafka.connect.json.JsonConverter",
          "internal.value.converter": "org.apache.kafka.connect.json.JsonConverter",
          "value.converter": "org.apache.kafka.connect.json.JsonConverter",
          "transforms": "unwrap",
          "transforms.unwrap.type": "io.debezium.connector.mongodb.transforms.ExtractNewDocumentState"
       }
    }'
}

index_topic() {
	curl -X PUT "bnm:9200/$1" -H 'Content-Type: application/json' -d'{ "settings" : { "index" : { } }}'
}

delete_all_index () {
	curl -X DELETE 'http://bnm:9200/_all'
}

list_index() {
	curl -s 'bnm:9200/_cat/indices?v'
}


search() {
	curl -s 'http://bnm:9200/test/_search?pretty' \
		-H "Content-Type: application/json" \
		-d "{
			  \"query\": {
				\"bool\": {
				  \"must\": {
				    \"match\": {
					  \"$1\": \"$2\"
							}
					  }
				}
		  }
	}"
}
# $1:payload.newname $2 duy

delete_connector() {
	curl -iX DELETE "http://bnm:8083/connectors/$1"
}

# posgres
create_postgres_source() {
	curl --location --request POST 'http://bnm:8083/connectors' \
	--header 'Content-Type: application/json' \
	--data-raw '{
		  "name": "postgres-connector",
		  "config": {
			"connector.class": "io.debezium.connector.postgresql.PostgresConnector",
			"tasks.max": "1",
			"database.hostname": "postgres",
			"database.port": "5432",
			"database.user": "postgres",
			"database.password": "postgres",
			"database.dbname" : "postgres",
			"database.server.name": "postgresdb",
			"key.converter": "org.apache.kafka.connect.json.JsonConverter",
			"value.converter": "org.apache.kafka.connect.json.JsonConverter",
			"key.converter.schemas.enable": "false",
			"value.converter.schemas.enable": "false",
			"database.history.kafka.bootstrap.servers": "kafka:29092",
			"database.history.kafka.topic": "schema-changes.test",
			"plugin.name": "pgoutput",
			"publication.autocreate.mode": "all_tables",
			"publication.name": "my_publication",
			"snapshot.mode": "always"
		}
	}'
}

$*
