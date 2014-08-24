# CBITEmitter

Cordova plugin for transmitting JSON payloads.

## Platforms

Currently this is only written for iOS.

## Installation

From within the Cordova application directory:

    cordova plugin add <path to>/CBITEmitter

## Usage

    var emitter = new CBITEmitter(<URI of server>);
    emitter.emitData({ abra: "cadabra" });
