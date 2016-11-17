<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Detalhe do Usuário">
<jsp:body>
	<div class="page-content">
		<div class="mdl-grid">
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-color--white mdl-shadow--4dp content mdl-color-text--grey-800 mdl-cell mdl-cell--10-col">
				<h4>Detalhes do Usuário</h4>
				<br/>
				<h5>Nome</h5>
				<p>${usuario.nome }</p>
				<h5>Usuário</h5>		
				<p>${usuario.username }</p>			
				<h5>Valor por KM</h5>		
				<p>${usuario.valorPagoKm }</p>			
			</div>
		</div>
	</div>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<a href="${s:mvcUrl('UC#form').build() }">
			<button id="fab" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--colored mdl-button--raised fab" >
				<div class="icon material-icons">add</div>
			</button>
			<label class="mdl-tooltip mdl-tooltip--left" for="fab">Cadastrar Usuário</label>
		</a>
	</sec:authorize>
</jsp:body>
</tags:pageTemplate>