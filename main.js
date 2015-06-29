/**
 * Created by xuchenhui on 2015/6/29.
 */

var Promise = require('bluebird'),
    handlers = require('./handlers.js'),
    _ = require('underscore');
var endOfLine = require('os').EOL;


var XssJsp = function(options){
    this.options = options;
};

XssJsp.prototype.renderNode = function(node){
    var content, me = this, result = '', childContent = '';

    switch(node.type) {
        case 'tag':
            content = handlers.tag(node);
            break;
        case 'text':
            content = handlers.text(node);
            break;
        case 'comment':
            content = handlers.comment(node);
            break;
        default:
            content = '';
            break;
    }


    if (node.children && node.children.length) {
        _.each(node.children, function(val){
            childContent += me.renderNode(val);
        });
    }

    if (_.isString(content)) {
        result += content;
    }else{
        // Add begin
        if (content && content.begin) {
            result += content.begin;
        }

        // append child
        if (childContent) {
            result += childContent;
        }

        // Add end
        if (content && content.end) {
            result += content.end;
        }
    }
    return result;
};

XssJsp.prototype.renderNodes = function(nodes){
    var me = this, content = '';

    if (!nodes || !nodes.length){
        return '';
    }

    _.each(nodes, function(val){
        content += me.renderNode(val);
    });

    return content;
};

module.exports = XssJsp;