<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"
      integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">

<link href="<c:url value="${urlHelper.getForLookupPath('/css/AdminLTE.min.css')}"/>" rel="stylesheet">
<link href="<c:url value="${urlHelper.getForLookupPath('/css/skins/_all-skins.min.css')}"/>" rel="stylesheet">

<link href="<c:url value="${urlHelper.getForLookupPath('/css/admin.css')}"/>" rel="stylesheet">


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
        integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
        crossorigin="anonymous"></script>
<script src="<c:url value="${urlHelper.getForLookupPath('/js/jquery.slimscroll.min.js')}"/>"></script>

<script type="text/javascript" src="<c:url value="${urlHelper.getForLookupPath('/js/select2.js')}"/>"></script>
<script type="text/javascript" src="<c:url value="${urlHelper.getForLookupPath('/js/select2-ko.js')}"/>"></script>

<!-- form validation -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/parsley.js/2.8.1/parsley.min.js"></script>
<script type="text/javascript" src="<c:url value="${urlHelper.getForLookupPath('/js/parsley-ko.js')}"/>"></script>

<!-- 파일 업로드 -->
<link rel="stylesheet" type="text/css"
      href="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/css/jquery.fileupload.min.css"/>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/vendor/jquery.ui.widget.min.js"></script>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/jquery.iframe-transport.min.js"></script>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/jquery.fileupload.min.js"></script>

<!-- jquery serialize object -->
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>

<!-- handlebars -->
<script type="text/javascript" src="<c:url value="${urlHelper.getForLookupPath('/js/handlebars.min-v4.2.0.js')}"/>"></script>

<!-- date picker -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/locale/ko.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>

<!-- datatables -->
<link rel="stylesheet" type="text/css" href="<c:url value="${urlHelper.getForLookupPath('/css/dataTables.bootstrap.min.css')}"/>"/>
<script type="text/javascript" src="<c:url value="${urlHelper.getForLookupPath('/js/jquery.dataTables.min.js')}"/>"></script>
<script type="text/javascript" src="<c:url value="${urlHelper.getForLookupPath('/js/dataTables.bootstrap.min.js')}"/>"></script>

<script src="<c:url value="${urlHelper.getForLookupPath('/js/adminlte.min.js')}"/>"></script>
<script src="<c:url value="${urlHelper.getForLookupPath('/js/admin.js')}"/>"></script>

<link rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
