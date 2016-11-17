<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Lista de Atendimentos">
<jsp:attribute name="modal">
	<dialog class="mdl-dialog">
	    <h4 class="mdl-dialog__title">Apagar Atendimento?</h4>
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
	  deletaAtendimento(id);
	  dialog.close();
	});
  </script>
</jsp:attribute>

<jsp:body>
	<div class="page-content">
		<div class="mdl-grid">
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-color--white mdl-color-text--grey-800 mdl-cell mdl-cell--10-col filtro_atendimento" >
				  <h6>Filtrar:</h6>
				  <sec:authorize access="hasRole('ROLE_SUP')">
					  <div class="mdl-selectfield mdl-js-selectfield mdl-selectfield--floating-label">
						  <select name="tecnico" id="selectTecnicos" class="mdl-selectfield__select" >
						  		<option value=""></option>
						  	<c:forEach items="${tecnicos }" var="t">
						  		<option  value="${t.username }">${t.nome }</option>
						  	</c:forEach>
						  </select>
						  <label class="mdl-selectfield__label" for="selectTecnicos">Técnico</label>
					  </div>
				  </sec:authorize>
				  <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				    <input class="mdl-textfield__input" type="text" pattern="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d" id="dataInicial" name="dataInicial" value="${dataInicial }" />
				    <label class="mdl-textfield__label" for="dataInicial">Data Inicial</label>
				    <span class="mdl-textfield__error">Insira a data no formato dd/MM/yyyy</span>
				  </div>
				  <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				    <input class="mdl-textfield__input" type="text" pattern="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d" id="dataFinal" name="dataFinal" value="${dataFinal }" />
				    <label class="mdl-textfield__label" for="dataFinal">Data Final</label>
				    <span class="mdl-textfield__error">Insira a data no formato dd/MM/yyyy</span>
				  </div>
				  <button id="filtraAtendimento" type="button" onclick="filtraAtendimento()" class="mdl-button mdl-js-button mdl-button--primary">Filtrar</button>
			</div>
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-color--white mdl-shadow--4dp mdl-color-text--grey-800 mdl-cell mdl-cell--10-col">
				<table id="listaAtendimentos" class="mdl-data-table mdl-js-data-table tabela_atendimentos">
				  <thead>
				    <tr>
				      <th class="mdl-data-table__cell--non-numeric numero_chamado">Número do Chamado</th>
				      <th class="mdl-data-table__cell--non-numeric data_atendimento">Data do Atendimento</th>
				      <th class="mdl-data-table__cell--non-numeric origem">Origem</th>
				      <th class="mdl-data-table__cell--non-numeric destino">Destino</th>
				      <th class="mdl-data-table__cell--non-numeric km_rodado">KM Rodado</th>
				      <th class="mdl-data-table__cell--non-numeric acoes"></th>
				    </tr>
				  </thead>
				  <tbody>
					  <c:forEach items="${atendimento }" var="at">
					    <tr id="${at.id }">
					      <td>${at.numeroChamado }</td>
					      <td><fmt:formatDate value="${at.dataAtendimento.time}" type="both" pattern="dd/MM/yyyy" dateStyle="full"/></td>
					      <td class="mdl-data-table__cell--non-numeric">${at.origem }</td>
					      <td class="mdl-data-table__cell--non-numeric">${at.destino }</td>
					      <td>${at.kmRodado }</td>
					      <td>
					      	<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="${s:mvcUrl('AC#detalhe').arg(0,at.numeroChamado).build() }" id="detalhe${at.id }"><i class="icon material-icons">zoom_in</i></a>
					      	<label class="mdl-tooltip" for="detalhe${at.id }">Detalhe</label>
					      	<sec:authentication property="principal" var="principal"/>
					      	<sec:authorize access="hasRole('ROLE_TEC')">
		      					<c:if test="${principal.id eq at.usuario.id }">
							      	<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="${s:mvcUrl('AC#formEditar').arg(0,at.numeroChamado).build() }" id="editar${at.id }"><i class="material-icons">edit</i></a>
							      	<label class="mdl-tooltip" for="editar${at.id }">Editar</label>
							      	<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="#" id="delete${at.id }" onclick="mostraModal('${at.id }')"><i class="icon material-icons" >delete</i></a>
							      	<label class="mdl-tooltip" for="delete${at.id }">Deletar</label>
		      					</c:if>
					      	</sec:authorize>
					      </td>
			    		</tr>	
					  </c:forEach>
				  </tbody>
				</table>
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