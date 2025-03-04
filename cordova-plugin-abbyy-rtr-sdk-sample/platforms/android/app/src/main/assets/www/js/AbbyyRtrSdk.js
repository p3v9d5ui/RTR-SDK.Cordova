/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

var exec = require('cordova/exec');

module.exports = {
	/// Open modal dialog for Text Capture Scenario.
	startTextCapture: function (callback, options) {
		exec(callback, callback, "AbbyyRtrSdk", "startTextCapture", [options]);
	},

	/// Open modal dialog for Data Capture Scenario.
	startDataCapture: function (callback, options) {
		exec(callback, callback, "AbbyyRtrSdk", "startDataCapture", [options]);
	},

	/// Open modal dialog for Image Capture Scenario.
	startImageCapture: function (callback, options) {
		exec(callback, callback, "AbbyyRtrSdk", "startImageCapture", [options]);
	},

	startCaptureDataFromImage: function (callback, options) {
		exec(callback, callback, "AbbyyRtrSdk", "startCaptureDataFromImage", [options]);
	}
}
