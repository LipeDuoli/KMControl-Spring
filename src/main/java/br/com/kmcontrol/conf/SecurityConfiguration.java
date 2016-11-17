package br.com.kmcontrol.conf;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.filter.CharacterEncodingFilter;

import br.com.kmcontrol.dao.UsuarioDao;

@EnableWebSecurity
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
	
	@Autowired
	private UsuarioDao usuarioDao;

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        http.addFilterBefore(filter,CsrfFilter.class);
		
		http.authorizeRequests()
			.regexMatchers(HttpMethod.GET, "/atendimentos[/\\.]?").hasAnyRole("TEC", "SUP")
			.antMatchers(HttpMethod.GET, "/atendimentos/filtra").hasAnyRole("TEC", "SUP")
			.antMatchers(HttpMethod.GET, "/atendimentos/*").hasAnyRole("TEC", "SUP")
			.antMatchers(HttpMethod.GET, "/atendimentos/*/editar").hasRole("TEC")
			.antMatchers(HttpMethod.GET, "/atendimentos/cadastro").hasRole("TEC")
			.antMatchers(HttpMethod.POST, "/atendimentos/*/delete").hasRole("TEC")
			.antMatchers(HttpMethod.POST, "/atendimentos").hasRole("TEC")
			.regexMatchers("/usuarios[/\\.]?").hasRole("ADMIN")
			.antMatchers("/usuarios/**").hasRole("ADMIN")
			.regexMatchers("/relatorios[/\\.]?").hasAnyRole("TEC", "SUP")
			.antMatchers("/relatorios/**").hasAnyRole("TEC", "SUP")
			.antMatchers("/resources/**").permitAll()
			.antMatchers("/").authenticated()
			.anyRequest().authenticated()
			.and().formLogin().loginPage("/login").permitAll()
			.and().logout().logoutRequestMatcher(new AntPathRequestMatcher("/logout"));
	}
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(usuarioDao)
			.passwordEncoder(new BCryptPasswordEncoder());
	}
	
	

}
