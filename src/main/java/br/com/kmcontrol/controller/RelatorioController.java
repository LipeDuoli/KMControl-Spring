package br.com.kmcontrol.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Scope;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import br.com.kmcontrol.dao.UsuarioDao;
import br.com.kmcontrol.entity.Role;
import br.com.kmcontrol.entity.Usuario;

@Controller
@Scope(value=WebApplicationContext.SCOPE_REQUEST)
@RequestMapping("/relatorios")
public class RelatorioController {
	
	@Autowired
	DataSource dataSource;
	
	@Autowired
	private UsuarioDao usuarioDao;

	@Cacheable(value="listaRelatorio")
	@RequestMapping(value = "", method=RequestMethod.GET)
	public ModelAndView home(){
		ModelAndView view = new ModelAndView("relatorio/home_relatorio");
		Map<String, String> tipoRelatorio = new HashMap<String, String>();
		tipoRelatorio.put("Gastos", "relatorioGasto");
		view.addObject("tipoRelatorio", tipoRelatorio);
		view.addObject("tecnicos", usuarioDao.buscaUsuarioComRole(new Role("ROLE_TEC")));
		
		Calendar dataInicial = Calendar.getInstance();
		dataInicial.set(Calendar.DAY_OF_MONTH, 1);
		Calendar dataFinal = Calendar.getInstance();
		
		view.addObject("dataInicial", new SimpleDateFormat("dd/MM/yyyy").format(dataInicial.getTime()));
		view.addObject("dataFinal", new SimpleDateFormat("dd/MM/yyyy").format(dataFinal.getTime()));
		return view;
		
	}
	
	@RequestMapping(value="/relatorio")
	public ModelAndView relatorio(ModelMap modelMap, 
									ModelAndView view,
									@RequestParam(value = "tipoRelatorio") String tipoRelatorio,
									@RequestParam(value = "dataInicial") Calendar dataInicial,
									@RequestParam(value = "dataFinal") Calendar dataFinal,
									@RequestParam(value = "tecnico", required = false) Integer tecnico, 
									@AuthenticationPrincipal Usuario usuarioLogado, 
									RedirectAttributes attributes){
		if(tipoRelatorio == "" || dataInicial == null || dataFinal == null){
			attributes.addFlashAttribute("showMsg", "true");
			attributes.addFlashAttribute("msg", "ERRO: Preencha TODOS os Campos");
			return new ModelAndView("redirect:/relatorios");
		}
		
		modelMap.put("datasource", dataSource);
		modelMap.put("format", "pdf");
		modelMap.put("DATA_INI", dataInicial.getTime());
		modelMap.put("DATA_FIM", dataFinal.getTime());
		
		if(tecnico == null){
			modelMap.put("TECNICO", usuarioLogado.getId());			
			view = new ModelAndView("rel_GastoTecnico", modelMap);									
		} else if(tecnico > 0) {
			modelMap.put("TECNICO", tecnico);				
			view = new ModelAndView("rel_GastoTecnico", modelMap);						
		} else {
			modelMap.put("TECNICO", tecnico);				
			view = new ModelAndView("rel_GastoTodoTecnico", modelMap);			
		}
		
		return view;
	}
}
