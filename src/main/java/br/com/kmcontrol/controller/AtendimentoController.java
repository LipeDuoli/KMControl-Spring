package br.com.kmcontrol.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Scope;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import br.com.kmcontrol.dao.AtendimentosDao;
import br.com.kmcontrol.dao.UsuarioDao;
import br.com.kmcontrol.entity.Atendimento;
import br.com.kmcontrol.entity.Role;
import br.com.kmcontrol.entity.Usuario;
import br.com.kmcontrol.infra.FileSaver;
import br.com.kmcontrol.validation.AtendimentoValidation;

@Controller
@Transactional
@Scope(value=WebApplicationContext.SCOPE_REQUEST)
@RequestMapping("/atendimentos")
public class AtendimentoController {
	
	@Autowired
	private AtendimentosDao atendimentoDao;
	
	@Autowired
	private UsuarioDao usuarioDao;
	
	@Autowired
	private FileSaver fileSaver;
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		binder.addValidators(new AtendimentoValidation());
	}
	
	@Cacheable(value="listaAtendimento")
	@RequestMapping(value="", method=RequestMethod.GET)
	public ModelAndView listar(@AuthenticationPrincipal Usuario usuarioLogado){
		ModelAndView view = new ModelAndView("atendimento/lista_atendimento");
		
		Calendar dataInicial = Calendar.getInstance();
		dataInicial.set(Calendar.DAY_OF_MONTH, 1);
		
		view.addObject("atendimento", atendimentoDao.filtraAtendimento(usuarioLogado, dataInicial, null, null));
		view.addObject("dataInicial", new SimpleDateFormat("dd/MM/yyyy").format(dataInicial.getTime()));
		if(usuarioLogado.hasRole(new Role("ROLE_SUP"))){
			view.addObject("tecnicos", usuarioDao.buscaUsuarioComRole(new Role("ROLE_TEC")));
		}
		
		return view;
	}
	
	@RequestMapping(value="/cadastro", method=RequestMethod.GET)
	public ModelAndView form(Atendimento atendimento){
		ModelAndView view = new ModelAndView("atendimento/cadastro_atendimento");
		return view;
	}
	
	@CacheEvict(value={ "listaAtendimento", "filtroAtendimento" }, allEntries=true)
	@RequestMapping(value="", method=RequestMethod.POST)
	public ModelAndView insereOuAtualizaAtendimento(MultipartFile rat, @Valid Atendimento atendimento, BindingResult result, RedirectAttributes attributes, @AuthenticationPrincipal
            Usuario usuarioLogado){
		
		if (atendimento.getId() == null && atendimentoDao.verificaExistenciaChamado(atendimento.getNumeroChamado())){
			result.rejectValue("numeroChamado", "field.unique");
		}
		if(result.hasErrors()) {
			return form(atendimento);
		}
		if(!rat.isEmpty()){
			String path = fileSaver.write("rat", rat, atendimento);
			atendimento.setRatPath(path);			
		}
		
		atendimento.setUsuario(usuarioLogado);
		atendimentoDao.insereOuAtualiza(atendimento);
		attributes.addFlashAttribute("showMsg", "true");
		attributes.addFlashAttribute("msg", "Atendimento Cadastrado com Sucesso");
		
		return new ModelAndView("redirect:/atendimentos");
	}
	
	@RequestMapping(value="/{numeroChamado}", method=RequestMethod.GET)
	public ModelAndView detalhe(@PathVariable("numeroChamado") Long numeroChamado, @AuthenticationPrincipal Usuario usuarioLogado){
		ModelAndView view = new ModelAndView();
		try {
			Atendimento atendimento = atendimentoDao.pesquisaPorChamado(numeroChamado);
			if(atendimento.pertence(usuarioLogado) || usuarioLogado.hasRole(new Role("ROLE_SUP"))){
				view.setViewName("atendimento/detalhe_atendimento");
				view.addObject("atendimento", atendimento);
				view.addObject("dataDir", System.getenv("OPENSHIFT_DATA_DIR"));
			} else {
				view.setViewName("atendimento/error_page");
				view.addObject("erroMsg", "Atendimento pertence a outro técnico");
			}
		} catch (Exception e) {
			view.setViewName("atendimento/error_page");
			view.addObject("erroMsg", "Atendimento não encontrado");
		}
		
		return view;
	}
	
	@CacheEvict(value={ "listaAtendimento" , "filtroAtendimento" }, allEntries=true)
	@RequestMapping(value="/{id}/delete", method=RequestMethod.POST)
	public void delete(@PathVariable("id") Integer id, HttpServletResponse response, @AuthenticationPrincipal Usuario usuarioLogado){
		Atendimento atendimento = atendimentoDao.pesquisaPorId(id);
		if(!atendimento.pertence(usuarioLogado)){
			response.setStatus(401);
		} else {
			atendimentoDao.delete(id);
			fileSaver.delete(atendimento.getRatPath());
			response.setStatus(200);			
		}
		
	}
	
	@RequestMapping(value="/{numeroChamado}/editar", method=RequestMethod.GET)
	public ModelAndView formEditar(@PathVariable("numeroChamado") Long numeroChamado, @AuthenticationPrincipal Usuario usuarioLogado, RedirectAttributes attributes){
		Atendimento atendimento = atendimentoDao.pesquisaPorChamado(numeroChamado);
		ModelAndView view = new ModelAndView();
		if(!atendimento.pertence(usuarioLogado)){
			view.setViewName("redirect:/atendimentos");
			attributes.addFlashAttribute("showMsg", "true");
			attributes.addFlashAttribute("msg", "Edição Não Autorizada");
		} else {
			view.setViewName("atendimento/cadastro_atendimento");
			view.addObject("atendimento", atendimentoDao.pesquisaPorChamado(numeroChamado));
		}
		
		return view;
	}
	
	@Cacheable(value="filtroAtendimento")
	@RequestMapping(value="/filtra", method=RequestMethod.GET)
	public ModelAndView filtra(@RequestParam(value = "dataInicial", required = false) Calendar dataInicial,
								@RequestParam(value = "dataFinal", required = false) Calendar dataFinal,
								@RequestParam(value = "tecnico", required = false) String tecnico,
								@AuthenticationPrincipal Usuario usuarioLogado){
		
		ModelAndView view = new ModelAndView("atendimento/filtro_atendimento");
		
		if(usuarioLogado.hasRole(new Role("ROLE_SUP"))){
			view.addObject("atendimento", atendimentoDao.filtraAtendimento(usuarioLogado, dataInicial, dataFinal, usuarioDao.buscaUsuario(tecnico)));			
		} else {
			view.addObject("atendimento", atendimentoDao.filtraAtendimento(usuarioLogado, dataInicial, dataFinal, null));						
		}		
		return view;
	}
	
	@RequestMapping(value="/{numeroChamado}/rat", method=RequestMethod.GET)
	public void downloadRat(@PathVariable("numeroChamado") Long numeroChamado, @AuthenticationPrincipal Usuario usuarioLogado, HttpServletResponse response, HttpServletRequest request) throws IOException{
		ModelAndView view = new ModelAndView();
		File file = null;
		try {
			Atendimento atendimento = atendimentoDao.pesquisaPorChamado(numeroChamado);
			if(atendimento.pertence(usuarioLogado) || usuarioLogado.hasRole(new Role("ROLE_SUP"))){
				file = new File(request.getServletContext().getRealPath("/") + atendimento.getRatPath());
				String mimeType= URLConnection.guessContentTypeFromName(file.getName());
		        if(mimeType==null){
		            System.out.println("mimetype is not detectable, will take default");
		            mimeType = "application/octet-stream";
		        }
		        response.setContentType(mimeType);
		        response.setHeader("Content-Disposition", String.format("inline; filename=\"" + file.getName() +"\""));
		        response.setContentLength((int)file.length());
		        InputStream inputStream = new BufferedInputStream(new FileInputStream(file));
		        FileCopyUtils.copy(inputStream, response.getOutputStream());
			} else {
				view.setViewName("atendimento/error_page");
				view.addObject("erroMsg", "RAT pertence a outro técnico");
			}
		} catch (Exception e) {
			String errorMessage = "Sorry. The file you are looking for does not exist";
            System.out.println(errorMessage);
            e.printStackTrace();
            OutputStream outputStream = response.getOutputStream();
            outputStream.write(errorMessage.getBytes(Charset.forName("UTF-8")));
            outputStream.close();
            return;
		}
	}
}