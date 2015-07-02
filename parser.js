var htmlparser = require('htmlparser'),
    Promise = require('bluebird');

// Derective filter
htmlparser.DefaultHandler._emptyTags['<!'] = 1;
htmlparser.DefaultHandler._emptyTags['%@'] = 1;
htmlparser.DefaultHandler._emptyTags['%--'] = 1;
htmlparser.DefaultHandler._emptyTags['%----%'] = 1;
// Derective closet name
htmlparser.DefaultHandler._emptyTags['%@page'] = 1;
htmlparser.DefaultHandler._emptyTags['%@include'] = 1;
htmlparser.DefaultHandler._emptyTags['%@taglib'] = 1;

var _promiseParser = Promise.method(function(content, options){
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

var parser = function(content, options) {
    if (options && options.cleanJspComments) {
        content = cleanJspComments(content);
    }
    var handler = new htmlparser.DefaultHandler(null, options);
    var parser = new htmlparser.Parser(handler, options);
    parser.parseComplete(content);
    return parser._handler.dom;
};

var promiseParser = function(content, options) {
    if (options && options.cleanJspComments) {
        content = cleanJspComments(content);
    }

    return promiseParser(content);
};


module.exports = {
    parser : parser,
    promiseParser: promiseParser
};