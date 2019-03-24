import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Header extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Enumeration e = request.getHeaderNames();
        while (e.hasMoreElements()) {
            String name = (String)e.nextElement();
            String value = request.getHeader(name);
            out.println("<BR><BR>" + name + " = " + value);
        }
    }
}


