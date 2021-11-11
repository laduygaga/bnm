sleep 5 && mongo --eval "rs.initiate()" &
mongod --port 27017 --replSet rs0 --bind_ip_all
