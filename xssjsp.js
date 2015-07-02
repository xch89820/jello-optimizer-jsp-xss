/**
 * Created by xuchenhui on 2015/6/29.
 */

var Promise = require('bluebird'),
    handlers = require('./handlers.js'),
    _ = require('underscore');
var endOfLine = require('os').EOL;

var XssJsp = function(options){
    this.options = options || {};
    this.blacklist = this.options.blacklist || [];

    this.blacklist.unshift(/^fn:escapeXml/i);
    this._useFn = false;
};

/**
 * Render node
 * @param node
 * @returns {string}
 */
XssJsp.prototype.renderNode = function(node){
    var content, me = this, result = '', childContent = '';

    content = handlers.specTag(node, me.blacklist);
    if (!content) {
        switch(node.type) {
            case 'tag':
                content = handlers.tag(node, me.blacklist);
                break;
            case 'text':
                content = handlers.text(node, me.blacklist);
                if (content !== node.data){
                    me._useFn = true;
                }
                break;
            case 'comment':
                content = handlers.comment(node, me.blacklist);
                break;
            case 'script':
            case 'style':
                content = handlers.scriptAndStyle(node, me.blacklist);
                break;
            default:
                content = handlers.directive(node, me.blacklist);
                break;
        }
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

    // Analysis tags
    _.each(nodes, function(val){
        content += me.renderNode(val);
    });

    var existFn = me.existFnTag(nodes);
    if (me._useFn && !existFn){
        content = '<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>' + endOfLine + content;
    }
    return content;
};

// Find taglib's fn tag
XssJsp.prototype.existFnTag = function(doms){
    var me = this;
    if (doms && _.isArray(doms)){
        var exists = _.filter(doms ,function (dom){
            return !!me.existFnTag(dom);
        });
        return !!exists.length;
    }else{
        if (doms.type == 'tag') {
            if (doms.name == '%@taglib' || doms.name == '%@'){
                if (doms.attribs && doms.attribs.prefix == 'fn'){
                    return true;
                }
            }
        }
    }
    return false;
};

module.exports = XssJsp;