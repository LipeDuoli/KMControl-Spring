!function(){"use strict";var e=function(e){this.element_=e,this.init()};window.MaterialSelectfield=e,e.prototype.Constant_={},e.prototype.CssClasses_={LABEL:"mdl-selectield__label",SELECT:"mdl-selectfield__select",IS_DIRTY:"is-dirty",IS_FOCUSED:"is-focused",IS_DISABLED:"is-disabled",IS_INVALID:"is-invalid",IS_UPGRADED:"is-upgraded"},e.prototype.onFocus_=function(e){this.element_.classList.add(this.CssClasses_.IS_FOCUSED)},e.prototype.onBlur_=function(e){this.element_.classList.remove(this.CssClasses_.IS_FOCUSED)},e.prototype.onReset_=function(e){this.updateClasses_()},e.prototype.updateClasses_=function(){this.checkDisabled(),this.checkValidity(),this.checkDirty()},e.prototype.checkDisabled=function(){this.select_.disabled?this.element_.classList.add(this.CssClasses_.IS_DISABLED):this.element_.classList.remove(this.CssClasses_.IS_DISABLED)},e.prototype.checkDisabled=e.prototype.checkDisabled,e.prototype.checkValidity=function(){this.select_.validity.valid?this.element_.classList.remove(this.CssClasses_.IS_INVALID):this.element_.classList.add(this.CssClasses_.IS_INVALID)},e.prototype.checkValidity=e.prototype.checkValidity,e.prototype.checkDirty=function(){this.select_.value&&this.select_.value.length>0?this.element_.classList.add(this.CssClasses_.IS_DIRTY):this.element_.classList.remove(this.CssClasses_.IS_DIRTY)},e.prototype.checkDirty=e.prototype.checkDirty,e.prototype.disable=function(){this.select_.disabled=!0,this.updateClasses_()},e.prototype.disable=e.prototype.disable,e.prototype.enable=function(){this.select_.disabled=!1,this.updateClasses_()},e.prototype.enable=e.prototype.enable,e.prototype.change=function(e){e&&(this.select_.value=e),this.updateClasses_()},e.prototype.change=e.prototype.change,e.prototype.init=function(){this.element_&&(this.label_=this.element_.querySelector("."+this.CssClasses_.LABEL),this.select_=this.element_.querySelector("."+this.CssClasses_.SELECT),this.select_&&(this.boundUpdateClassesHandler=this.updateClasses_.bind(this),this.boundFocusHandler=this.onFocus_.bind(this),this.boundBlurHandler=this.onBlur_.bind(this),this.select_.addEventListener("change",this.boundUpdateClassesHandler),this.select_.addEventListener("focus",this.boundFocusHandler),this.select_.addEventListener("blur",this.boundBlurHandler),this.updateClasses_(),this.element_.classList.add(this.CssClasses_.IS_UPGRADED)))},e.prototype.mdlDowngrade_=function(){this.select_.removeEventListener("change",this.boundUpdateClassesHandler),this.select_.removeEventListener("focus",this.boundFocusHandler),this.select_.removeEventListener("blur",this.boundBlurHandler)},componentHandler.register({constructor:e,classAsString:"MaterialSelectfield",cssClass:"mdl-js-selectfield",widget:!0})}();

var dialog = document.querySelector('dialog');
var id = 0
var token = $("meta[name='_csrf']").attr("content");
var header = $("meta[name='_csrf_header']").attr("content");

$('#buscaChamado').change(function() {
  $('#formBusca').attr('action', '/atendimentos/' + this.value);
});

if (! dialog.showModal) {
	dialogPolyfill.registerDialog(dialog);
}

function mostraModal(idItem){
	dialog.showModal();
	id = idItem;
}	    
dialog.querySelector('.close').addEventListener('click', function() {
  dialog.close();
});

function mostraToast(mensagem){
	$.snackbar({content: mensagem});
}

function deletaAtendimento(id){
	$.ajax({
		type: "POST",
		url: "/atendimentos/" + id + "/delete",
		beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
		success: function(response){
			$("#"+id).remove();
			mostraToast("Atendimento Excluido com Sucesso");
		},
        error: function() {
        	mostraToast("Não foi possivel excluir atendimento");
		}
	});
}

function filtraAtendimento(){
	$.ajax({
		type: "GET",
		url: "/atendimentos/filtra",
		data: {
            dataInicial: $('#dataInicial').val(),
            dataFinal: $('#dataFinal').val(),
            tecnico: $('#selectTecnicos').val()
        },
		beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
		success: function(response){
			var result = $('<div />').append(response).find('#listaAtendimentos').html();
			$('#listaAtendimentos').html(result);
		},
        error: function() {
        	mostraToast("Não foi possivel filtrar os Atendimentos");
		}
	});
}

function deletaUsuario(id){
	$.ajax({
		type: "POST",
		url: "/usuarios/" + id + "/delete",
		beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
		success: function(response){
			$("#"+id).remove();
			mostraToast("Usuário Excluido com Sucesso");
		},
        error: function() {
        	mostraToast("Não foi possivel excluir usuário");
		}
	});
}