<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Cadastro de Usuário">
<jsp:body>
	<div class="page-content">
		<form:form action="${s:mvcUrl('UC#insereOuAtualizaUsuario').build() }" method="POST" commandName="usuario">
			<div class="mdl-grid">
				<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
				<div class="mdl-color--white mdl-shadow--4dp mdl-color-text--grey-800 mdl-cell mdl-cell--10-col content">
					<h4>${msgCadastro }</h4>
					<form:hidden path="id"/>
					<p>
						<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
							<form:input path="nome" cssClass="mdl-textfield__input" id="nome"/>
						    <label class="mdl-textfield__label" for="nome">Nome</label>
						    <form:errors cssClass="error_cadastro" path="nome" />
						</div>
					</p>
					<p>
						<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
							<form:input path="username" cssClass="mdl-textfield__input" id="username"/>
						    <label class="mdl-textfield__label" for="username">Usuário</label>
						    <form:errors path="username" cssClass="error_cadastro" />
						</div>
					</p>
					<p>
						<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
							<form:password path="password" class="mdl-textfield__input" id="password" />
						    <label class="mdl-textfield__label" for="password">Senha</label>
						    <form:errors path="password" cssClass="error_cadastro" />
						</div>
					</p>
					<p>
						<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
							<form:input path="valorPagoKm" cssClass="mdl-textfield__input" id="valorPagoKm" type="number" step="0.01" min="0" />
						    <label class="mdl-textfield__label" for="valorPagoKm">Valor por KM</label>
						    <form:errors path="valorPagoKm" cssClass="error_cadastro" />
						</div>
					</p>
					<p>Permissôes: </p>
					<p style="display: inline;">
						<c:forEach items="${roles }" var="role">
							<label for="${role }" class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" style="display: inline;padding-right: 5px;">
								<form:checkbox id="${role }" class="mdl-checkbox__input" path="roles" value="${role.role }"/>
								<span class="mdl-checkbox__label">${role.nome }</span>
							</label>
						</c:forEach>
					</p>
				</div>
			</div>
			
			<button id="fab" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--colored mdl-button--raised fab" type="submit">
				<i class="material-icons">save</i>
			</button>
			<label class="mdl-tooltip mdl-tooltip--left" for="fab">Cadastrar</label>
		</form:form>
	</div>
</jsp:body>
</tags:pageTemplate>