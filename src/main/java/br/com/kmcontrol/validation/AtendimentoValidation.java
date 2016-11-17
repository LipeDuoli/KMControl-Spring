package br.com.kmcontrol.validation;

import java.math.BigDecimal;
import java.util.Calendar;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import br.com.kmcontrol.entity.Atendimento;

public class AtendimentoValidation implements Validator{
	
	@Override
	public boolean supports(Class<?> clazz) {
		return Atendimento.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Atendimento atendimento = (Atendimento) target;
		Calendar dataAtual = Calendar.getInstance();
	
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "numeroChamado", "field.required");
		if(atendimento.getNumeroChamado() <= 0){
			errors.rejectValue("numeroChamado", "field.invalid");
		}
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "dataAtendimento", "field.required");
		if(atendimento.getDataAtendimento() != null && atendimento.getDataAtendimento().after(dataAtual)){
			errors.rejectValue("dataAtendimento", "field.invalid");
		}
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "origem", "field.required");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "destino", "field.required");
		if(atendimento.getKmRodado() <= 0){
			errors.rejectValue("kmRodado", "field.invalid");
		}
		if(atendimento.getGastoExtra() != null && atendimento.getGastoExtra().compareTo(BigDecimal.ZERO) <= 0){
			errors.rejectValue("gastoExtra", "field.invalid");
		}
	}

}
