<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table id="listaAtendimentos" class="mdl-data-table mdl-js-data-table" style="width: 100%;">
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
			<c:if test="${principal.id eq at.usuario.id }">
	      	<sec:authorize access="hasRole('ROLE_TEC')">
		      	<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="${s:mvcUrl('AC#formEditar').arg(0,at.numeroChamado).build() }" id="editar${at.id }"><i class="material-icons">edit</i></a>
		      	<label class="mdl-tooltip" for="editar${at.id }">Editar</label>
		      	<a class="mdl-button mdl-js-button mdl-button--icon mdl-button--accent" href="#" id="delete${at.id }" onclick="mostraModal('${at.id }')"><i class="icon material-icons" >delete</i></a>
		      	<label class="mdl-tooltip" for="delete${at.id }">Deletar</label>
	      	</sec:authorize>
			</c:if>
	      </td>
   		</tr>	
	  </c:forEach>
  </tbody>
</table>