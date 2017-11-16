import { NativeModules } from 'react-native';
var RCTPlayamr = NativeModules.Playamr;
var resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");

export default class Playamr {
    //callback: (error, event: {status}) => void)
    // status: 0:playing, 1:play success end, 2:play failed, 3: stop
    static play(name, callback) {
        let _filename = "";
        var asset = resolveAssetSource(name);
        if (asset) {
            _filename = asset.uri;
        } else {
            _filename = name;
        }
        RCTPlayamr.play(_filename, callback);
    }

    static stop() {
        RCTPlayamr.stop();
    }
}