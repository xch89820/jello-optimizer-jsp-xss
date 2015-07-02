<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/fis" prefix="fis" %>

<!-- Test include -->
<%@ include file="./header.jsp" %>

<!DOCTYPE html>
<fis:html mapDir="/map" framework="static/common/lib/mod/mod.js">
    <fis:head>
        <fis:require id="static/common/lib/jq-plugin/css/paging.css"/>
        <fis:require id="static/verify-manage/verify-ticket/css/verifyTicket.css"/>
        <fis:style>
            body {
                background-color: ${body-color}
            }
        </fis:style>
    </fis:head>

    <fis:body>
        <%-- comment --%>

        <!-- JSP variable -->
        <p class="cover-xss">
            This is an ${name}
        </p>

        <p id="not-cover">
            ${fn:escapeXml(name)}
        </p>

        <p id="mixed-cover">
            ${name} and ${fn:escapeXml(name)}
        </p>
        <!-- c:out  -->
        <p class="total">
            This is an <c:out value="name"/>
        </p>

        <!-- Set variable -->
        <c:set var="foo" value="${foo}" />

        <fis:require id="static/test.js"/>
        <fis:script>
            var name = ${name};
            var testLib = require('static/test.js');
            testLib.init(name, ${userType});
        </fis:script>
        <!-- HTML script -->
        <script id="recordListTpl" type="text/javascript">
            var num = ${num};
            if (num > 0){
                $("p").hide();
            }
        </script>
    </fis:body>
</fis:html>
