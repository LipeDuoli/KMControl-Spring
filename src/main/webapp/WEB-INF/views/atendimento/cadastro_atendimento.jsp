<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<tags:pageTemplate title="Cadastro de Atendimento">
<jsp:attribute name="extraScript">
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCym69OgvKgas0WHsmYRYjoNMs6_1DHTG8&libraries=places&language=pt_BR&oe=utf-8"></script>
	<script>
	var origem = document.getElementById('origem');
	var destino = document.getElementById('destino')
	var autocompleteOptions = {
        componentRestrictions: {country: 'br'},
		types: ['(cities)']
    };
	var origem_autocomplete = new google.maps.places.Autocomplete(origem, autocompleteOptions);
	var destino_autocomplete = new google.maps.places.Autocomplete(destino, autocompleteOptions);
	var directionsService = new google.maps.DirectionsService();
		
	origem_autocomplete.addListener('place_changed', calcRoute);
	destino_autocomplete.addListener('place_changed', calcRoute);

	
	function calcRoute() {
		  var start = document.getElementById('origem').value;
		  var end = document.getElementById('destino').value;
		  var request = {
		    origin:start,
		    destination:end,
		    travelMode: google.maps.TravelMode.DRIVING
		  };
		  if(start != null && end != null){
			  directionsService.route(request, function(result, status) {
			    if (status == google.maps.DirectionsStatus.OK) {
			    	$('#kmRodado').val(Math.round(result.routes[0].legs[0].distance.value / 1000))
			    }
			  });			  
		  }
		}

	</script>
</jsp:attribute>

<jsp:body>
	<div class="page-content">
		<form:form action="${s:mvcUrl('AC#insereOuAtualizaAtendimento').build() }" method="POST" commandName="atendimento" enctype="multipart/form-data">
			<div class="mdl-grid">
				<div class="mdl-cell mdl-cell--1-col mdl-cell--hide-tablet mdl-cell--hide-phone"></div>
				<div class="mdl-color--white mdl-shadow--4dp mdl-color-text--grey-800 mdl-cell mdl-cell--10-col content">
				<form:hidden path="id"/>
				<c:if test="${empty atendimento.id }">
					<h4>Cadastrar Atendimento</h4>
					<p>
						<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
							<form:input path="numeroChamado" cssClass="mdl-textfield__input" id="numeroChamado" pattern="-?[0-9]*(\.[0-9]+)?" type="number" min="0"/>
						    <label class="mdl-textfield__label" for="numeroChamado">Número do Chamado</label>
						    <span class="mdl-textfield__error">Insira somente números</span>
						    <form:errors cssClass="error_cadastro" path="numeroChamado" />
						</div>
					</p>				
				</c:if>
				<c:if test="${not empty atendimento.id }">
					<h4>Editar Atendimento ${atendimento.numeroChamado }</h4>
					<form:hidden path="numeroChamado"/>
				</c:if>
				<p>
					<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
						<form:input path="dataAtendimento" cssClass="mdl-textfield__input" id="dataAtendimento" pattern="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d" />
					    <label class="mdl-textfield__label" for="dataAtendimento">Data do Atendimento</label>
					    <span class="mdl-textfield__error">Insira a data no formato dd/MM/yyyy</span>
					    <form:errors path="dataAtendimento" cssClass="error_cadastro" />
					</div>
				</p>
				<p>
					<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
						<form:input path="origem" class="mdl-textfield__input" id="origem" placeholder="." />
					    <label class="mdl-textfield__label" for="origem">Origem</label>
					    <form:errors path="origem" cssClass="error_cadastro" />
					</div>
				</p>
				<p>
					<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
						<form:input path="destino" class="mdl-textfield__input" id="destino" placeholder="." />
					    <label class="mdl-textfield__label" for="destino">Destino</label>
					    <form:errors path="destino" cssClass="error_cadastro" />
					</div>
				</p>
				<p>
					<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
						<form:input path="kmRodado" class="mdl-textfield__input" pattern="-?[0-9]*(\.[0-9]+)?" id="kmRodado" type="number" min="0"/>
					    <label class="mdl-textfield__label" for="kmRodado">KM Rodado</label>
					    <span class="mdl-textfield__error">Insira somente números</span>
					    <form:errors path="kmRodado" cssClass="error_cadastro" />
					</div>
				</p>
				<p>
					<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
						<form:input path="gastoExtra" class="mdl-textfield__input" id="gastoExtra" type="number" step="0.01" min="0" />
					    <label class="mdl-textfield__label" for="gastoExtra">Gastos Extras</label>
					    <form:errors path="gastoExtra" cssClass="error_cadastro" />
					</div>
				</p>
				<p>
					<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
						<form:textarea path="obs" class="mdl-textfield__input" id="obs" />
					    <label class="mdl-textfield__label" for="obs">Observações do Atendimento</label>
					</div>
				</p>
				<p>
					<div class="mdl-file mdl-js-file mdl-file--floating-label">
						<input name="rat" type="file" id="rat" accept=".pdf,.jpg,.png"/>
					    <label class="mdl-file__label" for="rat">RAT</label>
					</div>
				</p>
				<form:hidden path="ratPath"/>
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