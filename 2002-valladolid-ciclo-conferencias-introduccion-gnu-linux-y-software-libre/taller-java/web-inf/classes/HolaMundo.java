import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class HolaMundo extends HttpServlet
{

// Metodo a ejecutar en respuesta de una petición GET

public void doGet (HttpServletRequest request,
                    HttpServletResponse response)
                    throws ServletException, IOException
{
 // Definimos cadenas que usaremos despues
  String title = "HOLA MUNDO!!";

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
  out.println("<P>Que tal el taller de Java Servlet...");
  out.println("<BR><BR><BR>");
  out.println("...espero que os este gustando ;-)");
  out.println("</BODY></HTML>");

 // CERRAMOS EL OBJETO DE SALIDA!! (recolector?)
  out.close();
}
}

