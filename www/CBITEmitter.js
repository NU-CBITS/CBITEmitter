var exec = require('cordova/exec');

function CBITEmitter(serverURI) {
  this._serverURI = serverURI;
}

CBITEmitter.prototype.emitData = function(data) {
  var json = JSON.stringify(data);

  function success() {}

  function error() {}

  exec(success, error, "CBITEmitter", "emitData", [this._serverURI, json]);
};

window.CBITEmitter = CBITEmitter;
