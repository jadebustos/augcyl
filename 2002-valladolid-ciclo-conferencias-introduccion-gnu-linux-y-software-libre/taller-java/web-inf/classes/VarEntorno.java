import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class VarEntorno extends HttpServlet
{

// Metodo a ejecutar en respuesta de una petición GET

public void doGet (HttpServletRequest request,
                    HttpServletResponse response)
                    throws ServletException, IOException
{
 // Definimos cadenas que usaremos despues
  String title = "Variables de entorno";

 // Creamos los objetos para imprimir la salida,...
  PrintWriter out;

 //Seleccionamos el tipo de contenido que va a devolver el Servlet
  response.setContentType("text/html");

 //Enlazamos el objeto respuesta a nuestro objeto de salida
  out = response.getWriter();

 //Empezamos a generar la pagina!!!!
 // Tenemos que escribir el codigo HTML

  out.println("<HTML><HEAD><TITLE>");
  out.println(title);
  out.println("</TITLE></HEAD><BODY>");
  out.println("<H1>" + title + "</H1>");
  out.println("<BR><BR><BR>");


out.println("PATH_URI  "+
request.getRequestURI()+ "<BR><BR>");

out.println("SERVER_PROTOCOL  "+
request.getProtocol()+ "<BR><BR>");


out.println("CONTENT_LENGTH  "+
request.getContentLength()+ "<BR><BR>");


out.println("AUTH_TYPE  "+

request.getAuthType()+ "<BR><BR>");


out.println("CONTENT_TYPE  "+

request.getContentType()+ "<BR><BR>");


out.println("PATH_INFO  "+


request.getPathInfo()+ "<BR><BR>");


out.println("PATH_TRANSALTED  "+

request.getPathTranslated()+ "<BR><BR>");


out.println("QUERY_STRING  "+

request.getQueryString()+ "<BR><BR>");


out.println("REMOTE_ADDR  "+

request.getRemoteAddr()+ "<BR><BR>");


out.println("REMOTE_HOST  "+

request.getRemoteHost()+ "<BR><BR>");


out.println("REMOTE_USER  "+

request.getRemoteUser()+ "<BR><BR>");


out.println("REQUEST_METHOD  "+

request.getMethod()+ "<BR><BR>");


out.println("SCRIPT_NAME  "+

request.getServletPath()+ "<BR><BR>");


out.println("SERVER_NAME  "+

request.getServerName()+ "<BR><BR>");


out.println("SERVER_PORT  "+

request.getServerPort()+ "<BR><BR>");




  out.println("</BODY></HTML>");

 // CERRAMOS EL OBJETO DE SALIDA!! (recolector?)
  out.close();
}
}
