package br.com.kmcontrol.dao;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;

import br.com.kmcontrol.entity.Role;
import br.com.kmcontrol.entity.Usuario;

@Repository
public class UsuarioDao implements UserDetailsService {
	
	@PersistenceContext
	EntityManager em;

	@Override
	public UserDetails loadUserByUsername(String username) {
		List<Usuario> usuarios = em.createQuery("select u from Usuario u where u.username = :username", Usuario.class)
									.setParameter("username", username)
									.getResultList();
		if (usuarios.isEmpty()) {
			throw new UsernameNotFoundException("Usuário não encontrado");
		}
		
		return usuarios.get(0);
	}
	
	public Usuario buscaUsuario(String username){
		List<Usuario> usuario = em.createQuery("select u from Usuario u where u.username = :username", Usuario.class).setParameter("username", username).getResultList();
		if(usuario.isEmpty()){
			return null;
		}
		return usuario.get(0);
	}
	
	public List<Usuario> getUsuarios(){
		return em.createQuery("select u from Usuario u", Usuario.class).getResultList();
	}
	
	public void insereOuAtualiza(Usuario usuario) {
		if(usuario.getId() == null){
			em.persist(usuario);
		} else {
			em.merge(usuario);
		}
	}
	
	public List<Usuario> buscaUsuarioComRole(Role role){
		return em.createQuery("select u from Usuario u where :role member of u.roles", Usuario.class).setParameter("role", role).getResultList();
	}

	public void delete(Integer id) {
		em.createQuery("delete from Usuario u where u.id = :id").setParameter("id", id).executeUpdate();	
	}

}
