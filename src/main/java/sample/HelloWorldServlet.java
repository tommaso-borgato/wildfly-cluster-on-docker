package sample;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * @author tborgato
 * @since 18.04.17
 */
@WebServlet(name = "HelloWorldServlet", urlPatterns = { "/helloworld" })
public class HelloWorldServlet extends HttpServlet {

    private static final String KEY_SERIAL = HelloWorldServlet.class + "-KEY_SERIAL";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Integer serial = (Integer) session.getAttribute(KEY_SERIAL);
        if (serial==null){serial=0;}
        resp.getWriter().append("Tutto a posto a ferragosto [" + serial + "]").flush();
        session.setAttribute(KEY_SERIAL, serial + 1);
        resp.setHeader("Content-Type", "plain/text");
    }
}
