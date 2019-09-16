package seoul.democracy.common.config;

import java.util.concurrent.TimeUnit;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.resource.ContentVersionStrategy;
import org.springframework.web.servlet.resource.VersionResourceResolver;

@Configuration
@EnableWebMvc
public class DemosWebConfig extends WebMvcConfigurerAdapter {
  @Override public void addResourceHandlers(final ResourceHandlerRegistry registry) {
    VersionResourceResolver versionResourceResolver = new VersionResourceResolver()
        .addVersionStrategy(new ContentVersionStrategy(), "/**");
    registry.addResourceHandler("/js/*.js", "/tinymce/*.js", "/css/*.css")
        .addResourceLocations("/js/", "/tinymce/", "/css/")
        .setCacheControl(CacheControl.maxAge(365, TimeUnit.DAYS))
        .resourceChain(true)
        .addResolver(versionResourceResolver);
  }
}