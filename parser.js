var htmlparser = require('htmlparser'),
    Promise = require('bluebird');

htmlparser.DefaultHandler._emptyTags['%@'] = 1;
htmlparser.DefaultHandler._emptyTags['%--'] = 1;

var promiseParser = Promise.method(function(content, options){
    return new Promise(function(resolve, reject) {
        var handler = new htmlparser.DefaultHandler(function (err, dom) {
            if (err) {
                reject(err);
            } else {
                resolve(dom);
            }
        }, options);
        var parser = new htmlparser.Parser(handler);
        parser.parseComplete(content);
    });
});
var cleanJspComments = function (content) {
    return content.replace(/<%--[\s\S]*?--%>/g, '');
};

module.exports = function(content, options){
    if (options && options.cleanJspComments) {
        content = cleanJspComments(content);
    }

    return promiseParser(content);
};