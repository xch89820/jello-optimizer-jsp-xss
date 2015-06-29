<%@page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/fis" prefix="fis"%>

<!DOCTYPE html>
<fis:html mapDir="/map" framework="static/common/lib/mod/mod.js">
    <head>
        <jsp:include page="../../../common/jsp/meta.jsp" />

        <jsp:include page="../../../common/jsp/style.jsp" />
        <fis:require id="static/common/lib/jq-plugin/css/paging.css"/>
        <fis:require id="static/verify-manage/verify-ticket/css/verifyTicket.css"/>
        <fis:styles/>

    </head>
    <body>
    <jsp:include page="../../../common/jsp/head.jsp" />
    <div class="lbc-content">
        <jsp:include page="../../../common/jsp/left.jsp" />
        <span id="userType" style="display:none;">${userType}</span>
        <div id="lbc-sidebar" class="sidebar"></div>
        <div id="lbc-main" class="main verify-main">
            <div id="verifyCodeTab" class="lbc-tab">
                <!-- 验券tab -->
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#verify-single" hidefocus=”true”>单券|储值卡验证</a></li>
                    <li><a href="#verify-batch" hidefocus=”true”>批量验证</a></li>
                    <li><a href="#verify-quickly" hidefocus=”true”>极速验证</a></li>
                        <%-- <c:if test="${1 == userType || 3 == userType || 6 == userType || true != openSelfVerify}"> --%>
                    <c:if test="${0 != openSelfVerify}">
                        <li>
                            <a href="#verifySelf" hidefocus=”true”>顾客自助验券</a>
                            <div class="un-count-tip" style="display: none;">您有<span class="un-count">20条</span>未处理验券请求</div>
                        </li>
                    </c:if>
                    <!--<li class="verify-help" ><a target="_blank" href="http://help.nuomi.com/2014-07-28/1414609357.html" data-disabled=false hidefocus=”true”>单券验证指南</a></li>-->
                    <li class="right"><a class="link help" target="_blank" data-disabled="false" href="http://help.nuomi.com/2015-05-28/1439361719.html">无法验证券码?</a></li>
                </ul>

                <!-- tab panes -->
                <div class="tab-pane" id="verify-single">
                    <div class="callout callout-warning">当天的接待，请务必当天完成验证，晚验证导致的退款将无法结款！</div>
                    <div class="verify-bar">
                        <!--增加选择分店功能-->
                        <c:if test="${userType != 4 && fn:length(data) != 0}">
                            <div class="verify-form" style="margin-bottom: 10px;">
                                <div class="verify-title">请选择分店</div>
                                <div class="input-border">
                                    <select class="verify-type single-code">

                                    </select>
                                </div>
                                <div class="verify-left tip-content">
                                    <p class="tip-error single-branch-error" style="display:none;">请选择一个分店</p>
                                </div>
                                <div class="clear"></div>
                            </div>
                        </c:if>
                        <div class="verify-form" style="margin-bottom: 10px;">
                            <div class="verify-title">请输入12位糯米券码或储值卡验证码</div>
	                            <span class="input-border">
	                                <input type="text" class="verify-code verify-single-code" autocomplete="off" value="">
	                                <span class="clear-icon">x</span>
                                </span>
                            <a href="javascript:void(0);" disabled class="btn btn-primary btn-lg verify-single-submit"  hidefocus=”true”>验证</a>
                            <div class="clear"></div>
                        </div>
                        <div class="tip-content">
                            <p class="tip-success single-success" style="display:none;"></p>
                        </div>
                        <div style="clear: both; height: 0; overflow: hidden;"></div>
                        <div class="tip-content">
                            <p class="tip-error error-msg single-error" style="display:none;"></p>
                        </div>
                            <%--<div class="tip-content">--%>

                            <%--<p class="tip-success single-success" style="display:none;"></p>--%>
                            <%--</div>--%>
                            <%--<div class="tip-content">--%>
                            <%--<!--p class="tip-text single-caution">当天的接待，请务必当天完成验证，晚验证导致的退款将无法结款！</p-->--%>
                            <%--<p class="tip-error error-msg single-error" style="display:none;"></p>--%>
                            <%--</div>--%>
                            <%--<p id="jump-verify-quickly" class="tip-text batch-info"><a href="javascript:void(0);">一次验证多张糯米券，使用极速验证更快捷。</a></p>--%>
                    </div>
                    <!-- 广告代码 -->
                        <%-- 移除广告代码至底部 --%>
                        <%--<div class="ad-wraper">--%>
                        <%--<iframe noscroll scrolling="no" border="0" frameBorder="0" src="/static/common/ad-2.html" width="750px" height="50px" name="ad-2">--%>
                        <%----%>
                        <%--</iframe>--%>
                        <%--</div>--%>
                    <div id="verifyRecordPanel" class="lbc-tab">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#verify-ticket-record" hidefocus="”true”">糯米券最近消费记录</a></li>
                            <li><a href="#storecard-record" hidefocus="”true”">储值卡最近消费记录</a></li>
                            <li class="clear"></li>
                        </ul>
                        <div class="tab-pane" id="verify-ticket-record" class="tab-pane">
                            <div class="verify-record-view">
                                <div class="head-title">
                                    <div class="verify-left">操作记录</div>
                                    <a href="/coupon/query/consumption/index" class="verify-right read-day-record">查看当天消费记录</a>
                                </div>
                                <table class="table" width="100%">
                                    <tr>
                                        <th width="22%">项目名称</th>
                                        <th width="11%">价格</th>
                                            <%--<th width="11%">套餐</th>--%>
                                        <th width="10%">糯米券密码</th>
                                        <th width="21%">消费时间</th>
                                        <th width="13%">验证账号</th>
                                        <th width="12%">分店名称</th>
                                    </tr>
                                </table>
                                <div class="record-list"></div>
                                <div class="paging"></div>
                            </div>
                        </div>
                        <div class="tab-pane" id="storecard-record" class="tab-pane">
                            <div class="storecard-record-view">
                                <div class="head-title">
                                    <div class="verify-left">操作记录</div>
                                </div>
                                <table class="table" width="100%">
                                    <tr>
                                            <%--<th width="15%">顾客</th>--%>
                                        <th width="16%">储值卡验证码</th>
                                        <th width="13%">消费时间</th>
                                        <th width="14%">项目</th>
                                        <th width="12%">消费金额</th>
                                        <th width="15%">特权</th>
                                        <th width="13%">验证账号</th>
                                        <th width="16%">消费门店</th>
                                    </tr>
                                </table>
                                <div class="record-list store-record-list"></div>
                                <div class="paging"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="verify-batch" style="display:none;">
                    <jsp:include page="verify-batch.jsp" />
                </div>
                <div class="tab-pane" id="verify-quickly" style="display: none;">
                    <jsp:include page="verify-quickly.jsp" />
                </div>
                <div class="tab-pane" id="verifySelf" style="display: none;">
                        <%--总店页面--%>
                        <%-- <c:if test="${1 == userType || 3 == userType || 6 == userType}"> --%>
                    <c:if test="${(1 == userType || 3 == userType || 6 == userType) && 1 == openSelfVerify}">
                        <jsp:include page="verifyMainStore.jsp" />
                    </c:if>
                        <%--分店页面--%>
                        <%-- <c:if test="${4 == userType && true == openSelfVerify}"> --%>
                    <c:if test="${2 == openSelfVerify || (4 == userType && 1 == openSelfVerify)}">
                        <jsp:include page="verifyBranchStore.jsp" />
                    </c:if>
                </div>
            </div>
        </div>
        <jsp:include page="../../../common/jsp/right.jsp" />
        <div class="clearfix"></div>
    </div>
    <div id="storeCardDialog" title="储值卡验证提示" style="display:none;">
        <div class="dialog-info" style="background: #fef6e7;border: 1px solid #e8e8e8;font-size: 12px;">
            储值卡一笔消费可能跨多个团单生成多个券码，请逐一验证所有券码并核对消费金额，避免漏验。
        </div>
        <div class="dialog-content"></div>
        <div class="dialog-button">
            <a href="javascript:void(0);" class="btn-verify-sure">确认</a>
            <a href="javascript:void(0);" class="btn-verify-close">取消</a>
        </div>
    </div>
    <div id="verifySingleDialog" title="验券提示" style="display:none;">
        <div class="dialog-content"></div>
        <div class="dialog-button">
            <a href="javascript:void(0);" class="btn-verify-close">取消</a>
        </div>
    </div>
    <div id="verifyMoreDialog" title="验券提示" style="display:none;">
        <div class="dialog-content"></div>
        <div class="dialog-button">
            <a href="javascript:void(0);" class="btn-verify-sure">确认</a>
            <a href="javascript:void(0);" class="btn-verify-close">取消</a>
        </div>
    </div>
    <!-- 验券最近消费记录 -->
    <script id="recordListTpl" type="text/html">
        <table class="table verify-tbody record-table" width="100%">
            {% for(var i = 0; i < data.length; i++){
            var m = data[i];
            var optionName = m.optionName || "--";
            %}
            <tr>
                <td width="22%">{%=m.itemName%}</td>
                <td width="11%">{%=m.price%}</td>
                    <%--<td width="11%">{%=optionName%}</td>--%>
                <td width="10%">{%=m.successCodes%}</td>
                <td width="21%">{%=m.useTime%}</td>
                <td width="13%">{%=m.operatorName%}</td>
                <td width="12%">{%=m.merchantName%}</td>
            </tr>
            {% } %}
        </table>
    </script>
    <!-- 储值卡最近消费记录 -->
    <script id="storeCardListTpl" type="text/html">
        <table class="table verify-tbody record-table" id="store-record-table" width="100%">
            {% for(var i = 0; i < data.length; i++){
            var m = data[i];
            var optionName = m.optionName || "--";
            %}
            <tr>
                    <%--<td width="15%">{%=m.customerPhone%}</td>--%>
                <td width="16%">{%=m.code%}</td>
                <td width="13%">{%=$coverTime(m.consumeTime)%}</td>
                <td width="14%">{%=m.dealName%}</td>
                <td class="storecard-cost" width="12%">{%=m.customePrice%}</td>
                <td class="storecard-ext toggle-box" width="15%">
                    {% if (m.ext) {
                    if ( m.ext.length > 5 ){
                    %}
                    {% for (var ei=0; ei < m.ext.length; ei++) {
                    var extStr = m.ext[ei];
                    if (ei <= 4) {
                    %}
                    <p><a href='/deal/promotion/confirmIndex' target='_blank'>{%=extStr%}</a></p>
                    {%  } else if (ei == 5) { %}
                    <a data-toggle class="toggle-title clearfix" href="javascript:void(0);"><span class="toggle-text more">查看更多</span>
                        <span class="ui-button-icon-primary ui-icon ui-icon-triangle-1-s toggle-ui"></span>
                    </a>
                    <div class="toggle-container">
                        <p><a href='/deal/promotion/confirmIndex' target='_blank'>{%=extStr%}</a></p>
                        {%  } else { %}
                        <p><a href='/deal/promotion/confirmIndex' target='_blank'>{%=extStr%}</a></p>
                        {%  } %}
                    </div>
                    {% } %}
                    {% } else {
                    for(var ei=0; ei < m.ext.length; ei++) {
                    var extStr = m.ext[ei];
                    %}
                    <p><a href='/deal/promotion/confirmIndex' target='_blank'>{%=extStr%}</a></p>
                    {%  }
                    } %}
                    {% } %}
                </td>
                <td width="13%">{%=m.operatorName%}</td>
                <td width="16%">{%=m.merchantName%}</td>
            </tr>
            {% } %}
        </table>
    </script>


    <jsp:include page="../../../common/jsp/foot.jsp" />
    <jsp:include page="../../../common/jsp/script.jsp" />
    <fis:require id="static/common/lib/art-template/template.js"/>
    <fis:require id="static/common/lib/jq-combobox/jquery.ui.combobox.js"/>
    <fis:require id="static/verify-manage/verify-ticket/js/verify-batch.js" />
    <fis:require id="static/common/lib/moment/moment.js"/>
    <fis:require id="static/verify-manage/verify-ticket/js/verify-quickly.js"/>
    <fis:require id="static/verify-manage/verify-ticket/js/verifyTicket.js"/>
    <fis:script>
        template.openTag = '{%';
        template.closeTag = '%}';
        //初始化菜单
        var mc = require("static/common/js/menu-config.js"),
        pc = require("static/common/js/privilege-config.js");
        $("#lbc-sidebar").jmenu(mc, 11 ,pc,'${userType}');
        var contextPath = '${fullPath}';
        var Ticket = require('static/verify-manage/verify-ticket/js/verifyTicket.js');
        Ticket.init();
        <%--总店逻辑--%>
        <%-- <c:if test="${1 == userType || 3 == userType || 6 == userType}"> --%>
        <c:if test="${(1 == userType || 3 == userType || 6 == userType) && 1 == openSelfVerify}">
            var ms = require("static/verify-manage/verify-ticket/js/verifyMainStore.js");
            ms.init();
        </c:if>
        <%--分店逻辑--%>
        <%-- <c:if test="${4 == userType && true == openSelfVerify}"> --%>
        <c:if test="${2 == openSelfVerify || (4 == userType && 1 == openSelfVerify)}">
            var bs = require("static/verify-manage/verify-ticket/js/verifyBranchStore.js");
            bs.init();
        </c:if>
    </fis:script>
        <%-- 测试UC可用 --%>
        <%--<jsp:include page="../../../common/jsp/uctest.jsp" />--%>

        <%-- 引入百度统计 --%>
    <jsp:include page="../../../common/jsp/static.jsp" />
    <fis:scripts/>
    </body>
</fis:html>