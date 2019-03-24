import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;


public class Formulario extends HttpServlet {

public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
                 throws ServletException, IOException {

 String title="Leer datos de un formulario";

 response.setContentType("text/html");

 PrintWriter out = response.getWriter();
 out.println("<HTML><HEAD><TITLE>");
 out.println(title);
 out.println("</TITLE></HEAD><BODY>");
 out.println("<H1>" + title + "</H1>");
 out.println("<BR><BR><BR>");

 Enumeration parNs = request.getParameterNames();
    while(parNs.hasMoreElements()) {
      String parN = (String)parNs.nextElement();
      out.println("<BR>" + parN +"       ");
      String[] parVls = request.getParameterValues(parN);

      if (parVls.length == 1) {
        String parVl = parVls[0];
        if (parVl.length() == 0)
          out.print("No especificado");
        else
          out.print(parVl);
      } else {
        for(int i=0; i<parVls.length; i++) {
          out.println("  " + parVls[i]);
        }
      }
    }
    out.println("</BODY></HTML>");
  }



}
