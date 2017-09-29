NAMESPACE ?= kafka
TW_TRACK ?= javascript

.PHONY: configure
configure:
	./bin/configure.sh

.PHONY: install
install:
	./bin/install.sh

.PHONY: start-untubo-producer
start-untubo-producer:
	helm install --name producer --namespace $(NAMESPACE) -f ./values/producer.yaml ./charts/nodejs

.PHONY: start-twitter-producer
start-twitter-producer:
	twurl --host stream.twitter.com '/1.1/statuses/filter.json?track=$(TW_TRACK)' | jq . | oc exec -ti $(NAMESPACE)-kafka-kafkacat -- kafkacat -P -b $(NAMESPACE)-kafka-headless:9092 -t twitter

.PHONY: start-twitter-consumer
start-twitter-consumer:
	oc -n $(NAMESPACE) exec -ti $(NAMESPACE)-kafka-kafkacat -- kafkacat -C -b k$(NAMESPACE)-kafka:9092 -t twitter

.PHONY: metadata
kafka-metadata:
	oc -n $(NAMESPACE) exec -ti $(NAMESPACE)-kafka-kafkacat -- kafkacat -b $(NAMESPACE)-kafka-headless:9092 -L
