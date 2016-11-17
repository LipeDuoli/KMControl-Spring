package br.com.kmcontrol.dao;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import br.com.kmcontrol.entity.Role;

@Repository
@Transactional
public class RoleDao {
	
	@PersistenceContext
	EntityManager em;
	
	public void inserir(Role role){
		em.persist(role);
	}
	
	public void pesquisaPorRole(String role){
		em.find(Role.class, role);
	}
	
	public List<Role> getRoles(){
		return em.createQuery("select r from Role r", Role.class).getResultList();
	}

}