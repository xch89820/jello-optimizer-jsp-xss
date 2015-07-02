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
var escapeText = function (value, blacklist) {
    // Has been escape
    //if (/\${fn:escapeXml}/.test(value)) {
    //    return value;
    //}
    value = value.replace(/\$\{([^}]*)\}/g, function(_, $1) {
        if ($1.indexOf('escapeXml') > -1 || inhitBlacklist(blacklist, $1)) {
            return '${' + $1 + '}';
        }
        return '${fn:escapeXml(' + $1 +  ')}';
    });
    return value;
};

/**
 * Filter in blacklist
 * @param blacklist
 * @param name
 * @returns {boolean}
 */
var inhitBlacklist = function (blacklist, name){
    var blacklist = blacklist,
        hited = false;
    blacklist.every(function(reg) {
        if (reg.test(name)) {
            hited = true;
            return false;
        }
        return true;
    });
    return hited;
};

// Detect tags
var is_jstlTag = function(name){
    return !!/^[a-zA-z]:/.test(name);
};
// is jsp or taglib tags
var is_jspTag = function(name){
    return !!(name.indexOf('%') > -1);
};
var is_documentType = function(name){
    return !!/^!DOCTYPE/.test(name);
};

/**
 * Some special tags
 * @param node
 * @param excludeEscape
 * @returns {string}
 */
handlers.specTag = function (node, blacklist) {
    var data = node.data ? node.data : node.raw;
    var content = '';
    switch (data) {
        case '%--':
            // Bad parse because inner tag like <%--<div ...>--%>
            // Ignore it
            content = '<%--';
            break;
        case '!--':
            content = '<!--';
            break;
        case '--%':
            // Bad parse because inner tag like <%--<div ...>--%>
            // Close it force
            content = '--%>';
            break;
        default :
            break;
    }
    return content;
};

/**
 * Handler tag
 * @param node
 * @returns {*}
 */
handlers.tag =  function (node, blacklist) {
    if (!node.name){
        return '';
    }

    var nodeName = node.name,
        isJspTag = is_jspTag(nodeName),
        isJstlTag = is_jstlTag(nodeName),
        isDocumentType = is_documentType(nodeName);

    // Deal with <% %> <!DOCTYPE ...>
    if (isJspTag || isDocumentType) {
        return handlers.directive(node, blacklist);
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
            }else if (!isJstlTag){
                begin += ' ' + name + '="' + escapeText(value, blacklist)  + '"';
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

handlers.text =  function (node, blacklist) {
    var content = escapeText(node.data, blacklist);
    return content;
};

handlers.comment = function (node, blacklist) {
    if (!node.data){
        return '';
    }

    return '<!--' + node.data + '-->';
};

handlers.directive = function (node, blacklist) {
    return '<' + (node.raw ? node.raw : node.data) + '>';
};

handlers.scriptAndStyle = function (node, blacklist) {
    if (!node.name){
        return '';
    }

    var end = '</' + node.name + '>',
        begin = '<' + node.name;
    if (node.attribs) {
        _.each(node.attribs, function (value, name) {
            if (name == value){
                begin += ' ' + name;
            }else {
                begin += ' ' + name + '="' + escapeText(value, blacklist)  + '"';
            }
        });
    }
    begin += '>';

    return {
        begin: begin,
        end: end
    };
};

module.exports = handlers;