package br.com.kmcontrol.controller;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Scope;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import br.com.kmcontrol.dao.RoleDao;
import br.com.kmcontrol.dao.UsuarioDao;
import br.com.kmcontrol.entity.Role;
import br.com.kmcontrol.entity.Usuario;
import br.com.kmcontrol.validation.UsuarioValidation;

@Controller
@Transactional
@Scope(value=WebApplicationContext.SCOPE_REQUEST)
@RequestMapping("/usuarios")
public class UsuarioController {
	
	@Autowired
	private UsuarioDao usuarioDao;
	
	@Autowired
	private RoleDao roleDao;
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		binder.addValidators(new UsuarioValidation());
	}
	
	@Cacheable(value="listaUsuarios")
	@RequestMapping(value="", method=RequestMethod.GET)
	public ModelAndView listar(){
		ModelAndView view = new ModelAndView("usuario/lista_usuario");
		view.addObject("usuarios", usuarioDao.getUsuarios());
		
		return view;
	}
	
	@RequestMapping(value="/cadastro", method=RequestMethod.GET)
	public ModelAndView form(Usuario usuario){
		ModelAndView view = new ModelAndView("usuario/cadastro_usuario");
		
		if(usuario.getId() == null){
			view.addObject("msgCadastro", "Cadastro de Usuário");			
		} else {
			view.addObject("msgCadastro", "Editar Usuário");						
		}
		view.addObject("roles", roleDao.getRoles());
		return view;
	}
	
	@CacheEvict(value={"listaUsuarios", "listaAtendimento", "listaRelatorio"}, allEntries=true)
	@RequestMapping(value="", method=RequestMethod.POST)
	public ModelAndView insereOuAtualizaUsuario(@Valid Usuario usuario, BindingResult result, RedirectAttributes attributes){
		
		if(usuario.getId() == null && usuarioDao.buscaUsuario(usuario.getUsername()) != null ){
			result.rejectValue("username", "field.unique");
		}
		
		if(result.hasErrors()) {
			return form(usuario);
		}
		
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		usuario.setPassword(encoder.encode(usuario.getPassword()));

		usuarioDao.insereOuAtualiza(usuario);
		attributes.addFlashAttribute("showMsg", "true");
		attributes.addFlashAttribute("msg", "Usuário Cadastrado com Sucesso");
		
		return new ModelAndView("redirect:/usuarios");
	}
	
	@RequestMapping(value="/{username}", method=RequestMethod.GET)
	public ModelAndView detalhe(@PathVariable("username") String username){
		ModelAndView view = new ModelAndView("usuario/detalhe_usuario");
		view.addObject("usuario", usuarioDao.loadUserByUsername(username));
		return view;
	}
	
	@CacheEvict(value={"listaUsuarios", "listaAtendimento"}, allEntries=true)
	@RequestMapping(value="/{id}/delete", method=RequestMethod.POST)
	public void delete(@PathVariable("id") Integer id, HttpServletResponse response, @AuthenticationPrincipal Usuario usuarioLogado){
		if(!usuarioLogado.hasRole(new Role("ROLE_ADMIN"))){
			response.setStatus(401);
		} else {
			usuarioDao.delete(id);		
			response.setStatus(200);			
		}
		
	}
	
	@RequestMapping(value="/{username}/editar", method=RequestMethod.GET)
	public ModelAndView formEditar(@PathVariable("username") String username, @AuthenticationPrincipal Usuario usuarioLogado, RedirectAttributes attributes){
		Usuario usuario = usuarioDao.buscaUsuario(username);
		ModelAndView view = new ModelAndView();

		view.setViewName("usuario/cadastro_usuario");
		view.addObject("usuario", usuario);
		view.addObject("roles", roleDao.getRoles());
		view.addObject("msgCadastro", "Editar Usuário");			
		
		return view;
	}

}
