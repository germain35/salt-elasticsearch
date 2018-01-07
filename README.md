# salt-elasticsearch-formula

curl -XPUT -u elastic 'localhost:9200/_xpack/security/user/elastic/_password' -H "Content-Type: application/json" -d '{
  "password" : "stupidpassword"
}'