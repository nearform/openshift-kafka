NAMESPACE ?= kafka
TW_TRACK ?= javascript

.PHONY: configure
configure:
	./bin/configure.sh

.PHONY: install
install:
	./bin/install.sh

.PHONY: start-untubo-pusher
start-untubo-pusher:
	helm install --name untubo --namespace $(NAMESPACE) -f ./values/untubo.pusher.yaml ./charts/nodejs

.PHONY: start-twitter-pusher
start-twitter-pusher:
	twurl --host stream.twitter.com '/1.1/statuses/filter.json?track=$(TW_TRACK)' | jq . | oc exec -ti $(NAMESPACE)-kafka-kafkacat -- kafkacat -P -b $(NAMESPACE)-kafka-headless:9092 -t twitter

.PHONY: start-twitter-puller
start-twitter-puller:
	oc -n $(NAMESPACE) exec -ti $(NAMESPACE)-kafka-kafkacat -- kafkacat -C -b $(NAMESPACE)-kafka:9092 -t twitter

.PHONY: metadata
kafka-metadata:
	oc -n $(NAMESPACE) exec -ti $(NAMESPACE)-kafka-kafkacat -- kafkacat -b $(NAMESPACE)-kafka-headless:9092 -L
