var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');


var GFKPlugin = function() {};

GFKPlugin.SSA = function() {};
GFKPlugin.SST = function() {};

GFKPlugin.SSA.init = function(var1, var2) {
  exec(
    successHandler,
    errorHandler,
    "GFKPlugin",
    "initSSA",
    [var1 || null]
  );
};

function successHandler(success) {
  console.log("[GFKPlugin] OK: " + success);
}

function errorHandler(error) {
  console.error("[GFKPlugin] Error: " + error);
}

module.exports = GFKPlugin;
