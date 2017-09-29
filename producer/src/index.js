"use strict";

const envs = process.env;

const options = {
  "metadata.broker.list": `${envs.BROKER_HOSTNAME}:${envs.BROKER_PORT}`,
  "group.id": envs.GROUP_ID,
  topic: envs.TOPIC,
  key: envs.KEY
};

const kafkesque = require("untubo")(options);

let count = 0;
const interval = setInterval(function() {
  kafkesque.push({ hello: "world", count });
  console.log("sent", count);
  count++;
}, 500);

process.once("SIGINT", function() {
  clearInterval(interval);
  console.log("closing");
  kafkesque.stop(() => {
    console.log("closed");
  });
});
