#!/usr/bin/env node

var XssJsp = require('./xssjsp.js');
var parser = require('./parser.js');

module.exports = function(content, file, settings) {
    var xss = new XssJsp(settings);

    var dom = parser.parser(content, settings);
    return xss.renderNodes(dom);
};

module.exports.defaultOptions = {
    cleanJspComments: true
};
