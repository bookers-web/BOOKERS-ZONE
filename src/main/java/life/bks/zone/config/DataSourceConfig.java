package life.bks.zone.config;

import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;
import java.util.ArrayList;

@Configuration
@MapperScan(basePackages = "life.bks.zone.mapper", excludeFilters = @org.springframework.context.annotation.ComponentScan.Filter(type = org.springframework.context.annotation.FilterType.REGEX, pattern = "life\\.bks\\.zone\\.mapper\\.bookers\\..*"), sqlSessionTemplateRef = "sqlSessionTemplate")
@MapperScan(basePackages = "life.bks.zone.mapper.bookers", sqlSessionTemplateRef = "bookersSqlSessionTemplate")
public class DataSourceConfig {

    @Primary
    @Bean(name = "dataSource")
    @ConfigurationProperties(prefix = "spring.datasource")
    public HikariDataSource dataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
    }

    @Bean(name = "bookersDataSource")
    @ConfigurationProperties(prefix = "spring.datasource-bookers")
    public HikariDataSource bookersDataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
    }

    @Primary
    @Bean(name = "sqlSessionFactory")
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        sessionFactory.setTypeAliasesPackage("life.bks.zone.vo,life.bks.zone.domain");

        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        ArrayList<Resource> allResources = new ArrayList<>();
        allResources.addAll(java.util.Arrays.asList(resolver.getResources("classpath:mappers/*.xml")));
        allResources.addAll(java.util.Arrays.asList(resolver.getResources("classpath:mappers/ipauth/*.xml")));
        allResources.addAll(java.util.Arrays.asList(resolver.getResources("classpath:mappers/member/*.xml")));
        allResources.addAll(java.util.Arrays.asList(resolver.getResources("classpath:mappers/bom/*.xml")));
        allResources.addAll(java.util.Arrays.asList(resolver.getResources("classpath:mappers/front/**/*.xml")));

        sessionFactory.setMapperLocations(allResources.toArray(new Resource[0]));
        return sessionFactory.getObject();
    }

    @Primary
    @Bean(name = "sqlSessionTemplate")
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("sqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

    @Bean(name = "bookersSqlSessionFactory")
    public SqlSessionFactory bookersSqlSessionFactory(@Qualifier("bookersDataSource") DataSource bookersDataSource) throws Exception {
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(bookersDataSource);
        sessionFactory.setTypeAliasesPackage("life.bks.zone.domain");

        org.apache.ibatis.session.Configuration mybatisConfig = new org.apache.ibatis.session.Configuration();
        mybatisConfig.setMapUnderscoreToCamelCase(true);
        sessionFactory.setConfiguration(mybatisConfig);

        sessionFactory.setMapperLocations(
            new PathMatchingResourcePatternResolver().getResources("classpath:mappers/bookers/**/*.xml")
        );
        return sessionFactory.getObject();
    }

    @Bean(name = "bookersSqlSessionTemplate")
    public SqlSessionTemplate bookersSqlSessionTemplate(@Qualifier("bookersSqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

    @Bean(name = "bookersTransactionManager")
    public DataSourceTransactionManager bookersTransactionManager(@Qualifier("bookersDataSource") DataSource bookersDataSource) {
        return new DataSourceTransactionManager(bookersDataSource);
    }
}
