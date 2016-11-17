package br.com.kmcontrol.entity;

import java.math.BigDecimal;
import java.util.Calendar;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.springframework.format.annotation.DateTimeFormat;

@Entity
public class Atendimento {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;

	@Column(unique=true, nullable=false)
	private long numeroChamado;

	@DateTimeFormat
	@Column(nullable=false)
	@Temporal(TemporalType.DATE)
	private Calendar dataAtendimento = Calendar.getInstance();

	@Column(nullable=false)
	private String origem;
	
	@Column(nullable=false)
	private String destino;
	
	private int kmRodado;
	
	@Column(nullable=true)
	private BigDecimal gastoExtra;
	
	@Lob
	@Column(nullable=true)
	private String obs;
	
	@Column(nullable=true)
	private String ratPath;
	
	@ManyToOne
	private Usuario usuario;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public long getNumeroChamado() {
		return numeroChamado;
	}

	public void setNumeroChamado(long numeroChamado) {
		this.numeroChamado = numeroChamado;
	}

	public Calendar getDataAtendimento() {
		return dataAtendimento;
	}

	public void setDataAtendimento(Calendar dataAtendimento) {
		this.dataAtendimento = dataAtendimento;
	}

	public String getOrigem() {
		return origem;
	}

	public void setOrigem(String origem) {
		this.origem = origem;
	}

	public String getDestino() {
		return destino;
	}

	public void setDestino(String destino) {
		this.destino = destino;
	}

	public int getKmRodado() {
		return kmRodado;
	}

	public void setKmRodado(int kmRodado) {
		this.kmRodado = kmRodado;
	}

	public BigDecimal getGastoExtra() {
		return gastoExtra;
	}

	public void setGastoExtra(BigDecimal gastoExtra) {
		this.gastoExtra = gastoExtra;
	}

	public String getObs() {
		return obs;
	}

	public void setObs(String obs) {
		this.obs = obs;
	}

	public String getRatPath() {
		return ratPath;
	}

	public void setRatPath(String ratPath) {
		this.ratPath = ratPath;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}
	
	public boolean pertence(Usuario usuario){
		if(this.usuario.equals(usuario)){
			return true;
		}
		return false;
	}


}