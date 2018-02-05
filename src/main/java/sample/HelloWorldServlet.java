package sample;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.InetAddress;

/**
 * Servlet that stores attribute SESSION_ATTRIBUTE_KEY into HTTP session; HTTP session is replicated across wildfly cluster nodes;
 * @author tborgato
 * @since 18.04.17
 */
@WebServlet(name = "HelloWorldServlet", urlPatterns = { "/helloworld" })
public class HelloWorldServlet extends HttpServlet {

    private static final String SESSION_ATTRIBUTE_KEY = HelloWorldServlet.class + "-SESSION_ATTRIBUTE_KEY";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Integer serial = (Integer) session.getAttribute(SESSION_ATTRIBUTE_KEY);
        if (serial==null){serial=0;}
        resp.getWriter().append(
                String.format("Counter: %d [host: %s]", serial, InetAddress.getLocalHost().getHostAddress())
        ).flush();
        session.setAttribute(SESSION_ATTRIBUTE_KEY, serial + 1);
        resp.setHeader("Content-Type", "plain/text");
    }
}
