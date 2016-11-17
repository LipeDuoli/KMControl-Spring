<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Detalhe do Atendimento ${atendimento.numeroChamado }">
<jsp:body>
	<c:url value="/" var="ratPath" />
	<fmt:setLocale value="pt_BR"/>
	<div class="page-content">
		<div class="mdl-grid">
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-color--white mdl-shadow--4dp content mdl-color-text--grey-800 mdl-cell mdl-cell--10-col">
				<h4>Detalhes do Atendimento ${atendimento.numeroChamado }</h4>
				<br/>
				<h5>Data do Atendimento</h5>
				<p><fmt:formatDate value="${atendimento.dataAtendimento.time}" type="both" pattern="dd/MM/yyyy" dateStyle="full"/></p>
				<h5>Origem</h5>
				<p>${atendimento.origem }</p>
				<h5>Destino</h5>
				<p>${atendimento.destino }</p>
				<h5>KM Rodado</h5>
				<p>${atendimento.kmRodado }</p>
				<c:if test="${not empty atendimento.gastoExtra }">
					<h5>Gastos Extras</h5>
					<p><fmt:formatNumber value="${atendimento.gastoExtra }" type="currency"/></p>
				</c:if>
				<c:if test="${not empty atendimento.obs }">
					<h5>Observações do atendimento</h5>
					<p>${atendimento.obs }</p>
				</c:if>
				<c:if test="${not empty atendimento.ratPath }">
					<h5>RAT</h5>
					<a href="${s:mvcUrl('AC#downloadRat').arg(0,atendimento.numeroChamado).build() }" target="_blank"><button class="mdl-button mdl-js-button mdl-button--primary"><i class="material-icons">file_download</i> Baixar</button></a>
				</c:if>
				
			</div>
		</div>
	</div>
	<sec:authorize access="hasRole('ROLE_TEC')">
		<a href="${s:mvcUrl('AC#form').build() }">
			<button id="fab" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--colored mdl-button--raised fab" >
				<div class="icon material-icons">add</div>
			</button>
			<label class="mdl-tooltip mdl-tooltip--left" for="fab">Cadastrar Atendimento</label>
		</a>
	</sec:authorize>
</jsp:body>
</tags:pageTemplate>