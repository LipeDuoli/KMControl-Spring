<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>KMControl</title>
		<c:url value="/resources/css" var="cssPath" />
		<c:url value="/resources/js" var="jsPath" />
		<c:url value="/resources/images" var="imagesPath" />
		<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" type="text/css">
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<link rel="stylesheet" href="${cssPath }/material.min.css">
		<link rel="stylesheet" href="${cssPath }/styles.css">
	</head>
	<body>
		<div class="mdl-layout__container" >
			<div class="mdl-layout mdl-js-layout">
				<main class="mdl-layout__content" >
					<div class="mdl-grid">
						<img alt="Logo KMcontrol" src="${imagesPath }/logop.png" class="index_logo">
					</div>
					<form:form servletRelativeAction="/login" method="POST">
						<div class="mdl-grid index_card_space">
							<div class="mdl-card mdl-cell mdl-shadow--4dp index_card">
								<div class="mdl-card__title">
									<h4>Bem Vindo</h4>
								</div>
								<div class="mdl-card__supporting-text">
									<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
										<input class="mdl-textfield__input" type="text" id="username" name="username" autofocus>
										<label class="mdl-textfield__label" for="username">Usuário</label>
									</div>
									<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
								  		<input class="mdl-textfield__input" type="password" id="password" name="password">
								  		<label class="mdl-textfield__label" for="password">Senha</label>
								  	</div>
								</div>
								<div class="mdl-card__actions index_card_actions">
									<c:if test="${not empty error}">
										<label class="error_cadastro">${error}</label>
									</c:if>
									<div class="mdl-layout-spacer"></div>
								  	<button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored">Logar</button>
								</div>
							</div>
						</div>
					</form:form>
				</main>
			</div>
		</div>
	</body>
	<script src="${jsPath }/material.min.js"></script>
</html>