package br.com.kmcontrol.validation;

import java.math.BigDecimal;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import br.com.kmcontrol.entity.Usuario;

public class UsuarioValidation implements Validator{
	
	@Override
	public boolean supports(Class<?> clazz) {
		return Usuario.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Usuario usuario = (Usuario) target;
	
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "username", "field.required");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "password", "field.required");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "nome", "field.required");
		if(usuario.getValorPagoKm() != null && usuario.getValorPagoKm().compareTo(BigDecimal.ZERO) <= 0){
			errors.rejectValue("valorPagoKm", "field.invalid");
		}
	}

}
