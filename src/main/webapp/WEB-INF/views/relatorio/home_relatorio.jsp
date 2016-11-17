<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Relatorios">
<jsp:attribute name="extraScript">
	<script>
	<c:if test="${showMsg }">
	$(document).ready(function() {
		mostraToast("${msg}");
	});
	</c:if>
  </script>
</jsp:attribute>

<jsp:body>
	<div class="page-content">
		<div class="mdl-grid">
			<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
			<div class="mdl-color--white mdl-shadow--4dp mdl-color-text--grey-800 mdl-cell mdl-cell--10-col content">
				<h4>Relatórios</h4>
				<br />
				<form:form action="${s:mvcUrl('RC#relatorio').build() }" method="GET">
				<p>
					<div class="mdl-selectfield mdl-js-selectfield mdl-selectfield--floating-label">
						<select name="tipoRelatorio" id="selectRelatorio" class="mdl-selectfield__select" >
							<option value=""></option>
							<c:forEach items="${tipoRelatorio }" var="relatorio">
								<option  value="${relatorio.value }">${relatorio.key }</option>
							</c:forEach>
						</select>
					<label class="mdl-selectfield__label" for="selectRelatorio">Tipo Relatório</label>
					</div>
                </p>
				<sec:authorize access="hasRole('ROLE_SUP')">
					<p>
						<div class="mdl-selectfield mdl-js-selectfield mdl-selectfield--floating-label">
							<select name="tecnico" id="selectTecnicos" class="mdl-selectfield__select" >
							<option value="0">Todos</option>
								<c:forEach items="${tecnicos }" var="t">
									<option  value="${t.id }">${t.nome }</option>
								</c:forEach>
							</select>
							 <label class="mdl-selectfield__label" for="selectTecnicos">Técnico</label>
						</div>
					</p>
				</sec:authorize>
				<p>Periodo: 
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
				</p>	
				<p>
					<button type="submit" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored">Gerar</button>
				</p>
				</form:form>
			</div>
		</div>
	</div>
</jsp:body>
</tags:pageTemplate>