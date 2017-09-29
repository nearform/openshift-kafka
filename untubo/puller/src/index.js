"use strict";

const envs = process.env;

const options = {
  "metadata.broker.list": `${envs.BROKER_HOSTNAME}:${envs.BROKER_PORT}`,
  "group.id": envs.GROUP_ID,
  topic: envs.TOPIC,
  key: envs.KEY
};

const kafkesque = require("untubo")(options);

kafkesque.pull((data, cb) => {
  try {
    console.log("DATA: ", data);
  } catch (err) {
    console.log(err);
  }
  cb();
});

process.once("SIGINT", function() {
  console.log("closing");
  kafkesque.stop(function() {
    console.log("closed");
  });
});
