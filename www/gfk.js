var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');

var GFKPlugin = {
  SSA: {},
  SST: {}
};

GFKPlugin.SSA.init = function(mediaId) {
  exec(
    successHandler,
    errorHandler,
    "GFKSSAPlugin",
    "initStream",
    [mediaId]
  );
};

GFKPlugin.SSA.start = function(contentId, customParams) {
  exec(
    successHandler,
    errorHandler,
    "GFKSSAPlugin",
    "startStream",
    [contentId, customParams || null]
  );
};

GFKPlugin.SSA.playEvent = function() {
  exec(
    successHandler,
    errorHandler,
    "GFKSSAPlugin",
    "playEvent",
    [null]
  );
};

GFKPlugin.SSA.idleEvent = function() {
  exec(
    successHandler,
    errorHandler,
    "GFKSSAPlugin",
    "idleEvent",
    [null]
  );
};

function successHandler(success) {
  console.log("[GFKPlugin] OK: " + success);
}

function errorHandler(error) {
  console.error("[GFKPlugin] Error: " + error);
}

module.exports = GFKPlugin;
