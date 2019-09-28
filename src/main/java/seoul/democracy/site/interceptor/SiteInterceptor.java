package seoul.democracy.site.interceptor;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import seoul.democracy.user.utils.UserUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SiteInterceptor extends HandlerInterceptorAdapter {

    public SiteInterceptor() {
    }

    @Override
    public void postHandle(HttpServletRequest request,
                           HttpServletResponse response,
                           Object handler,
                           ModelAndView modelAndView) throws Exception {

        if (modelAndView == null || modelAndView.getViewName().startsWith("redirect:")) return;

        modelAndView.addObject("loginUser", UserUtils.getLoginUser());

        String controllerName = "";
        String actionName = "";

        if( handler instanceof HandlerMethod ) {
            // there are cases where this handler isn't an instance of HandlerMethod, so the cast fails.
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            //controllerName = handlerMethod.getBean().getClass().getSimpleName().replace("Controller", "");
            controllerName  = handlerMethod.getBeanType().getSimpleName().replace("Controller", "");
            actionName = handlerMethod.getMethod().getName();
        }

        modelAndView.addObject("controllerName", controllerName );
        modelAndView.addObject("actionName", actionName );
        modelAndView.addObject("environmentName", System.getProperty("spring.profiles.active", "default"));
    }
}
