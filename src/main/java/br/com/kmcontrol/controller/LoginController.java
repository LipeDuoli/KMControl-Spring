package br.com.kmcontrol.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public ModelAndView login(@RequestParam(value = "error", required = false) String error) {

			ModelAndView model = new ModelAndView("index");
			if (error != null) {
				model.addObject("error", "Usuario ou senha inválidos");
			}

			return model;

	}
	
	@RequestMapping(value="/logout")
	public String logout(){
		return "/";
	}

}
