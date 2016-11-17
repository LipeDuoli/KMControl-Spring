package br.com.kmcontrol.conf;

import java.util.Properties;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@EnableTransactionManagement
public class JPAConfiguration {

	@Bean
	public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
		LocalContainerEntityManagerFactoryBean factoryBean = new LocalContainerEntityManagerFactoryBean();

		JpaVendorAdapter jpaVendorAdapter = new HibernateJpaVendorAdapter();

		factoryBean.setJpaVendorAdapter(jpaVendorAdapter);

		factoryBean.setDataSource(dataSource());

		Properties props = new Properties();
		props.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL5Dialect");
		props.setProperty("hibernate.show_sql", "true");
		props.setProperty("hibernate.hbm2ddl.auto", "create"); //create create-drop update validate
		props.setProperty("hibernate.hbm2ddl.import_files", "import.sql");

		factoryBean.setJpaProperties(props);

		factoryBean.setPackagesToScan("br.com.kmcontrol.entity");

		return factoryBean;
	}

	@Bean
	public JpaTransactionManager transactionManager(EntityManagerFactory emf) {
		return new JpaTransactionManager(emf);
	}
	
	@Bean
	public DataSource dataSource(){
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		String username = System.getenv("OPENSHIFT_MYSQL_DB_USERNAME");
	    String password = System.getenv("OPENSHIFT_MYSQL_DB_PASSWORD");
	    String host = System.getenv("OPENSHIFT_MYSQL_DB_HOST");
	    String port = System.getenv("OPENSHIFT_MYSQL_DB_PORT");
	    String databaseName = System.getenv("OPENSHIFT_APP_NAME");
	    String url = "jdbc:mysql://" + host + ":" + port + "/"+databaseName;
	    dataSource.setDriverClassName("com.mysql.jdbc.Driver");
	    dataSource.setUrl(url);
	    dataSource.setUsername(username);
	    dataSource.setPassword(password);
		return dataSource;
	}
	
	
}
