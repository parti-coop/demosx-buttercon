<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<title>
  <c:if test="${environmentName ne 'production'}">DEV - </c:if>
  <c:if test="${not empty butter and butter.title ne ''}">${butter.title} - </c:if>
  <c:if test="${empty butter}">버터보드 - </c:if>
  버터나이프크루
</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="csrf-token" content="${ _csrf.token }">
<meta name="google-site-verification" content="Ojjkoy9iStRXnAjq1K9cdgxCE8Wzj-kojSjN-1ZONGE" />

<link rel="apple-touch-icon" sizes="57x57" href="${pageContext.request.contextPath}/favicon/apple-icon-57x57.png">
<link rel="apple-touch-icon" sizes="60x60" href="${pageContext.request.contextPath}/favicon/apple-icon-60x60.png">
<link rel="apple-touch-icon" sizes="72x72" href="${pageContext.request.contextPath}/favicon/apple-icon-72x72.png">
<link rel="apple-touch-icon" sizes="76x76" href="${pageContext.request.contextPath}/favicon/apple-icon-76x76.png">
<link rel="apple-touch-icon" sizes="114x114" href="${pageContext.request.contextPath}/favicon/apple-icon-114x114.png">
<link rel="apple-touch-icon" sizes="120x120" href="${pageContext.request.contextPath}/favicon/apple-icon-120x120.png">
<link rel="apple-touch-icon" sizes="144x144" href="${pageContext.request.contextPath}/favicon/apple-icon-144x144.png">
<link rel="apple-touch-icon" sizes="152x152" href="${pageContext.request.contextPath}/favicon/apple-icon-152x152.png">
<link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/favicon/apple-icon-180x180.png">
<link rel="icon" type="image/png" sizes="192x192"  href="${pageContext.request.contextPath}/favicon/android-icon-192x192.png">
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="96x96" href="${pageContext.request.contextPath}/favicon/favicon-96x96.png">
<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon/favicon-16x16.png">
<link rel="manifest" href="${pageContext.request.contextPath}/favicon/manifest.json">
<meta name="msapplication-TileColor" content="#ffffff">
<meta name="msapplication-TileImage" content="${pageContext.request.contextPath}/favicon/ms-icon-144x144.png">
<meta name="theme-color" content="#ffffff">

<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"
      integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css">


<link href="https://spoqa.github.io/spoqa-han-sans/css/SpoqaHanSans-kr.css" rel="stylesheet" type="text/css">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="${pageContext.request.contextPath}/css/main.css?v=<spring:eval expression="@pomProperties['version']" />" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/application.css?v=<spring:eval expression="@pomProperties['version']" />" rel="stylesheet">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
        integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
        crossorigin="anonymous"></script>

<!-- form validation -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/parsley.js/2.8.1/parsley.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/parsley-ko.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- select2 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/select2.js?v=<spring:eval expression="@pomProperties['version']" />"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/select2-ko.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- handlebars -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/handlebars.min-v4.2.0.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- jquery serialize object -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.serializeJSON/2.9.0/jquery.serializejson.min.js"></script>


<!-- 파일 업로드 -->
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/vendor/jquery.ui.widget.min.js"></script>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/jquery.iframe-transport.min.js"></script>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/jquery.fileupload.min.js"></script>

<!-- tinymce editor -->
<script type="text/javascript" src="${pageContext.request.contextPath}/tinymce/tinymce.min.js?v=<spring:eval expression="@pomProperties['version']" />"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/tinymce/jquery.tinymce.min.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- scroll-into -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/smooth-scroll-into-view-if-needed.min.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- form dirty check -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.dirrty.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- application -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/application.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- radio checkbox -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pretty-checkbox@3.0/dist/pretty-checkbox.min.css"/>

<!-- EasyMDE -->
<link rel="stylesheet" href="https://unpkg.com/easymde/dist/easymde.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendors/simplemde/simplemde-theme-dark.css?v=<spring:eval expression="@pomProperties['version']" />" rel="stylesheet">
<script src="https://unpkg.com/easymde/dist/easymde.min.js"></script>


<!-- Codemirror with merge -->
<script src="https://cdn.jsdelivr.net/npm/codemirror@5.48.4/lib/codemirror.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/diff_match_patch.js?v=<spring:eval expression="@pomProperties['version']" />"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/codemirror/merge.js?v=<spring:eval expression="@pomProperties['version']" />"></script>

<!-- Instagram embed -->
<script async src="//www.instagram.com/embed.js"></script>

<c:if test="${environmentName eq 'production'}">

  <!-- Global site tag (gtag.js) - Google Analytics -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=UA-148869553-1"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());

    gtag('config', 'UA-148869553-1');
  </script>

</c:if>
