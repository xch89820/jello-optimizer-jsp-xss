/**
 * Define some handler
 *
 */
var _ = require('underscore');
var handlers = {};

/**
 * Escape pure text
 * @param value
 * @returns {*}
 */
var escapeText = function(value) {
    // Has been escape
    //if (/\${fn:escapeXml}/.test(value)) {
    //    return value;
    //}
    value = value.replace(/\$\{([^}]*)\}/g, function(_, $1) {
        if ($1.indexOf('escapeXml') > -1) {
            return '${' + $1 + '}';
        }
        return '${fn:escapeXml(' + $1 +  ')}';
    });
    return value;
};

var passText = function(value){
    return value;
};


var is_jspTag = function(name){
    return !!(name.indexOf('%') > -1);
};
var is_documentType = function(name){
    return !!/^!DOCTYPE/.test(name);
};
/**
 * Handler tag
 * @param nodeContext
 * @returns {*}
 */
handlers.tag =  function(node) {
    if (!node.name){
        return '';
    }

    var nodeName = node.name,
        isJspTag = is_jspTag(nodeName),
        isDocumentType = is_documentType(nodeName);

    // Deal with <% %> <!DOCTYPE ...>
    if (isJspTag || isDocumentType){
        return handlers.directive(node);
    }

    var end, begin = '<' + node.name;
    switch (node.name) {
        case 'c:out':
            // { type: 'tag', name: 'c:out', attribs: { value: '${oy}' } }
            // Replace <c:out value="${oy}"> --> <c:out value="${oy}" escapeXml="true">
            node.attribs['escapeXml'] = "true";
            break;
        default:
            break;
    }

    if (node.attribs) {
        _.each(node.attribs, function (value, name) {
            if (name == value){
                begin += ' ' + name;
            }else{
                begin += ' ' + name + '="' + value  + '"';
            }

        });
    }

    if (node.children && node.children.length) {
        begin += '>';
        end = '</' + node.name + '>';
    }else{
        begin += '/>';
    }

    return {
        begin: begin,
        end: end
    };
};

handlers.text =  function(node) {
    var content = escapeText(node.data);
    return content;
};

handlers.comment = function(node) {
    if (!node.data){
        return '';
    }
    return '<!--' + node.data + '-->';
};
handlers.directive = function(node) {
    return '<' + (node.raw ? node.raw : node.data) + '>';
};

module.exports = handlers;