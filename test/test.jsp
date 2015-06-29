<%@ include file="./header.jsp"%>

<%-- trtret --%>
<!-- sfsdf-->
<c:set var="foo" value="${foo}" />

<c:set var="testSetContent">
</c:set>

<p><c:out value="${bean.userControlledValue}"></p>

<div id="test-set-content">
    ${foo}${fn:escapeXml(bar)}
    ${fn:escapeXml(foo)}
</div>
