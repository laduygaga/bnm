## mongo kafka elasticsearch
### build
```
docker-compose up
```

**testing for mongo**
### config mongo
```
docker exec -it mongo1 /bin/bash
mongo
rs.initiate(
  {
    _id : 'rs0',
    members: [
      { _id : 0, host : "mongo1:27017" },
      { _id : 1, host : "mongo2:27017" },
      { _id : 2, host : "mongo3:27017" }
    ]
  }
)
use admin
db.createUser(
  {
    user: 'duy',
    pwd: '123',
    roles: [ { role: 'root', db: 'admin' } ]
  }
);
```
### create mongo-connector
bash bnm.sh create_mongo_source

## postgres kafka elasticsearch
**testing for postgres** 
### create postgres-connector
bash bnm.sh create_postgres_source

**go to  adminer, create test data**
```
CREATE TABLE test (
    id SERIAL PRIMARY KEY,
    name VARCHAR (50),
    age SMALLINT
);

INSERT INTO "test" ("name", "age")
VALUES ('Duy', '25');
```

** use kafka manager port 9000 and test function in bnm.sh


### Install logstash
```
apt install logstash
```
### Run
/usr/share/logstash/bin/logstash -f kafka_input.conf
