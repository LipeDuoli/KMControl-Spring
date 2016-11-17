<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
	
<header class="header mdl-layout__header mdl-layout__header--waterfall">
	<div class="mdl-layout__header-row">
		<span class="title mdl-layout-title"> 
			<img class="logo-image" src="${imagesPath }/logop.png">
		</span>
		<!-- Add spacer, to align navigation to the right in desktop -->
		<div class="mdl-layout-spacer"></div>
		<sec:authorize access="hasAnyRole('ROLE_TEC', 'ROLE_SUP')">
			<div class="search-box mdl-textfield mdl-js-textfield mdl-textfield--expandable mdl-textfield--floating-label mdl-textfield--align-right mdl-textfield--full-width">
	            <label class="mdl-button mdl-js-button mdl-button--icon" for="buscaChamado">
	              <i class="material-icons">search</i>
	            </label>
	            <div class="mdl-textfield__expandable-holder">
	            <form:form action="" id="formBusca" method="get" >
	              <input class="mdl-textfield__input" type="number" id="buscaChamado" placeholder="Número do Chamado"/>
	            </form:form>
	            </div>
	        </div>
		</sec:authorize>
		
		<!-- Navigation -->
		<div class="navigation-container">
			<nav class="navigation mdl-navigation">
				<sec:authorize access="hasAnyRole('ROLE_TEC', 'ROLE_SUP')">
					<a class="mdl-navigation__link mdl-typography--text-uppercase" href="${s:mvcUrl('AC#listar').build() }">Atendimentos</a>
					<a class="mdl-navigation__link mdl-typography--text-uppercase" href="${s:mvcUrl('RC#home').build() }">Relatórios</a>
				</sec:authorize>
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<a class="mdl-navigation__link mdl-typography--text-uppercase" href="${s:mvcUrl('UC#listar').build() }">Usuários</a>
				</sec:authorize>
			</nav>
		</div>
		<span class="mobile-title mdl-layout-title"> 
			<img class="logo-image" src="${imagesPath }/logop.png">
		</span>
		<button class="more-button mdl-button mdl-js-button mdl-button--icon mdl-js-ripple-effect" id="more-button">
			<i class="material-icons">more_vert</i>
		</button>
		<ul class="mdl-menu mdl-js-menu mdl-menu--bottom-right mdl-js-ripple-effect" for="more-button">
			<sec:authorize access="hasAnyRole('ROLE_TEC', 'ROLE_SUP')">
				<a href="${s:mvcUrl('AC#listar').build() }" class="mdl-menu__item mdl-typography--text-uppercase">Atendimentos</a>
				<a href="${s:mvcUrl('RC#home').build() }" class="mdl-menu__item mdl-typography--text-uppercase">Relatórios</a>
			</sec:authorize>
			<sec:authorize access="hasRole('ROLE_ADMIN')">
				<a href="${s:mvcUrl('UC#listar').build() }" class="mdl-menu__item mdl-typography--text-uppercase">Usuários</a>
			</sec:authorize>
		</ul>
		<button id="userinfo" class="mdl-button mdl-js-button mdl-button--icon account_button">
		  <i class="material-icons">account_circle</i>
		</button>		
		<ul class="mdl-menu mdl-menu--bottom-right mdl-js-menu mdl-js-ripple-effect"
		    for="userinfo">
		  <li disabled class="mdl-menu__item"><sec:authentication property="principal.nome"/> </li>
		  <s:url value="/logout" var="logout" />
		  <a href="${logout }" class="mdl-menu__item">Sair</a>
		</ul>
	</div>
</header>