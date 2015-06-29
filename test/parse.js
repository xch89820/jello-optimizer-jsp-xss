var fs = require('fs');
var path = require('path');
var parser = require('../parser.js');
var XssJsp  = require('../main.js');

var xss = new XssJsp();
// render
var filePath = path.resolve(__dirname, 'test.jsp');
var content = fs.readFileSync(filePath);

parser(content.toString())
    .then(function(dom){
        console.log(dom);
       var res = xss.renderNodes(dom);
        console.log(res);
    });