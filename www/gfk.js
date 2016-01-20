var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');

var GFKPlugin = {
  SSA: {},
  SST: {}
};

GFKPlugin.SSA.init = function(mediaId, adId, configUrl) {
  exec(
    successHandler,
    errorHandler,
    "GFKPlugin",
    "initSSA",
    [mediaId, adId || null, configUrl || null]
  );
};

GFKPlugin.SSA.start = function(contentId, customParams) {
  exec(
    successHandler,
    errorHandler,
    "GFKPlugin",
    "startSSA",
    [contentId, customParams || null]
  );
};

function successHandler(success) {
  console.log("[GFKPlugin] OK: " + success);
}

function errorHandler(error) {
  console.error("[GFKPlugin] Error: " + error);
}

module.exports = GFKPlugin;
