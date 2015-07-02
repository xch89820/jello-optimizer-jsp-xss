var fs = require('fs');
var path = require('path');
var parser = require('../parser.js');
var XssJsp  = require('../xssjsp.js');

var xss = new XssJsp({
    blacklist: [/test_/i]
});
// render
var filePath = path.resolve(__dirname, 'test.jsp');
var content = fs.readFileSync(filePath);

var dom = parser.parser(content.toString(), {
    cleanJspComments: true
});
var result = xss.renderNodes(dom);
fs.writeFileSync('out.jsp', result);
//parser(content.toString())
//    .then(function(dom){
//        //console.log(dom);
//        var res = xss.renderNodes(dom);
//        return res;
//    }).then(function(result){
//        fs.writeFileSync('out.jsp', result);
//    });