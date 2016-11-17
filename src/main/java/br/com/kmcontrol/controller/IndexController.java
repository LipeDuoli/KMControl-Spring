package br.com.kmcontrol.controller;

import org.springframework.context.annotation.Scope;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.WebApplicationContext;

import br.com.kmcontrol.entity.Role;
import br.com.kmcontrol.entity.Usuario;

@Controller
@Scope(value=WebApplicationContext.SCOPE_REQUEST)
public class IndexController {

	@RequestMapping("/")
	public String index(@AuthenticationPrincipal Usuario usuarioLogado){
		if(usuarioLogado != null){			
			if(usuarioLogado.hasRole(new Role("ROLE_ADMIN")) && usuarioLogado.getRoles().size() <= 1){
				return "redirect:/usuarios";
			}
		}
		return "redirect:/atendimentos";
	}
}
