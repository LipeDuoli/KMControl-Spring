<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ attribute name="title" required="true"%>
<%@ attribute name="extraScript" fragment="true" %>
<%@ attribute name="modal" fragment="true" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<sec:csrfMetaTags />
		<title>KMControl - ${title }</title>
		<c:url value="/resources/css" var="cssPath" />
		<c:url value="/resources/js" var="jsPath" />
		<c:url value="/resources/images" var="imagesPath" />
		<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" type="text/css">
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<link rel="stylesheet" href="${cssPath }/material.min.css">
		<link rel="stylesheet" href="${cssPath }/snackbar.min.css">
		<link rel="stylesheet" href="${cssPath }/styles.css">
		<link rel="stylesheet" href="${cssPath }/material.components.ext.min.css">
		<script src="${jsPath }/dialog-polyfill.min.js"></script>
		<link rel="stylesheet" href="${cssPath }/dialog-polyfill.css">
	</head>
	<body>
		<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header" >
			<%@include file="/WEB-INF/views/cabecalho.jsp" %>
			<main class="mdl-layout__content" >
				<jsp:doBody />
			</main>
		</div>
		<jsp:invoke fragment="modal" />
	</body>
	<script src="${jsPath }/material.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
	<script src="${jsPath }/material.components.ext.min.js"></script>
	<script src="${jsPath }/scripts.js"></script>
	<script src="${jsPath }/snackbar.min.js"></script>
	<jsp:invoke fragment="extraScript" />
</html>