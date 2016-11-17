<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Lista de Usuários">
<jsp:attribute name="modal">
	<dialog class="mdl-dialog">
	    <h4 class="mdl-dialog__title">Apagar Usuário?</h4>
	    <div class="mdl-dialog__content">
	      <p>
	        Este procedimento não poderá ser desfeito.
	      <p>
	    </div>
	    <div class="mdl-dialog__actions">
	      <button type="button" class="mdl-button accept">Apagar</button>
	      <button type="button" class="mdl-button close">Cancelar</button>
	    </div>
	</dialog>
</jsp:attribute>

<jsp:attribute name="extraScript">
	<script>
	<c:if test="${showMsg }">
		$(document).ready(function() {
			mostraToast("${msg}");
		});
	</c:if>
	dialog.querySelector('.accept').addEventListener('click', function() {
	  deletaUsuario(id);
	  dialog.close();
	});
  </script>
</jsp:attribute>

<jsp:body>
	<div class="page-content">
		<div class="mdl-grid">
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-color--white mdl-shadow--4dp mdl-color-text--grey-800 mdl-cell mdl-cell--10-col">
				<ul class="mdl-list">
					<c:forEach items="${usuarios }" var="usuario">
						<li class="mdl-list__item mdl-list__item--two-line" id="${usuario.id }">
							<span class="mdl-list__item-primary-content">
								<i class="material-icons mdl-list__item-avatar">person</i>
								<span>${usuario.nome }</span>
								<span class="mdl-list__item-sub-title">${usuario.roles }</span>
							</span>
							<span class="mdl-list__item-secondary-content" style="flex-direction: row;">
								<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="${s:mvcUrl('UC#detalhe').arg(0,usuario.username).build() }" id="detalhe${usuario.id }"><i class="material-icons">zoom_in</i></a>
								<label class="mdl-tooltip" for="detalhe${usuario.id }">Detalhe</label>
								<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="${s:mvcUrl('UC#formEditar').arg(0,usuario.username).build() }" id="editar${usuario.id }"><i class="material-icons">edit</i></a>
								<label class="mdl-tooltip" for="editar${usuario.id }">Editar</label>
								<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="#" id="deletar${usuario.id }" onclick="mostraModal('${usuario.id }')"><i class="material-icons">delete</i></a>
								<label class="mdl-tooltip" for="deletar${usuario.id }">Deletar</label>
							</span>
						</li>
					</c:forEach>
				</ul>
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