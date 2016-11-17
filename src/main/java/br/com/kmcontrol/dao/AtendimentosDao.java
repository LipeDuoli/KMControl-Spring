package br.com.kmcontrol.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import br.com.kmcontrol.entity.Atendimento;
import br.com.kmcontrol.entity.Role;
import br.com.kmcontrol.entity.Usuario;

@Repository
public class AtendimentosDao {
	
	@PersistenceContext
	private EntityManager em;
	
	public void insereOuAtualiza(Atendimento atendimento){
		if(atendimento.getId()== null){
			em.persist(atendimento);
		} else {
			em.merge(atendimento);
		}
	}

	public List<Atendimento> getAtendimentos() {
		return em.createQuery("select a from Atendimento a", Atendimento.class).getResultList();
	}
	
	public Atendimento pesquisaPorChamado(long numeroChamado){
		List<Atendimento> atendimento = em.createQuery("select a from Atendimento a where a.numeroChamado = :numeroChamado", Atendimento.class)
				.setParameter("numeroChamado", numeroChamado)
				.getResultList();
		if (atendimento.isEmpty()) {
			throw new RuntimeException("Atendimento não encontrado");
		}		
		return atendimento.get(0);
	}
	
	public Atendimento pesquisaPorId(Integer id){
		return em.find(Atendimento.class, id);
	}
	
	public boolean verificaExistenciaChamado(long numeroChamado){
		List<Atendimento> atendimento = em.createQuery("select a from Atendimento a where a.numeroChamado = :numeroChamado", Atendimento.class)
				.setParameter("numeroChamado", numeroChamado)
				.getResultList();
		if (atendimento.isEmpty()) {
			return false;
		}		
		return true;
	}

	public void delete(Integer id) {
		em.createQuery("delete from Atendimento a where a.id = :id").setParameter("id", id).executeUpdate();
	}
	
	public void update(Atendimento atendimento){
		em.merge(atendimento);
	}

	public List<Atendimento> filtraAtendimento(Usuario usuarioLogado, Calendar dataInicial, Calendar dataFinal, Usuario usuarioPesquisa) {
		CriteriaBuilder builder = em.getCriteriaBuilder();
		CriteriaQuery<Atendimento> criteriaQuery = builder.createQuery(Atendimento.class);
		Root<Atendimento> root = criteriaQuery.from(Atendimento.class);
		List<Predicate> criteriaList = new ArrayList<Predicate>();
		Predicate user;
		if(usuarioLogado.hasRole(new Role("ROLE_SUP")) && usuarioPesquisa != null){
			user = builder.equal(root.get("usuario"), usuarioPesquisa);
		} else {
			user = builder.equal(root.get("usuario"), usuarioLogado);
		}
		criteriaList.add(user);			
		
		if(dataInicial != null){
			Predicate inicio = builder.greaterThanOrEqualTo(root.<Calendar>get("dataAtendimento"), dataInicial);
			criteriaList.add(inicio);
		}
		if(dataFinal != null){
			Predicate fim = builder.lessThanOrEqualTo(root.<Calendar>get("dataAtendimento"), dataFinal);
			criteriaList.add(fim);
		}		
		
		criteriaQuery.where(builder.and(criteriaList.toArray(new Predicate[0])));
		criteriaQuery.orderBy(builder.asc(root.get("dataAtendimento")));
		TypedQuery<Atendimento> query = em.createQuery(criteriaQuery);
		return query.getResultList();
	}

}
