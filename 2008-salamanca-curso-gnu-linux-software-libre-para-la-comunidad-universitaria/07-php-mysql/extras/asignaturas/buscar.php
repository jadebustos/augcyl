<?php
//incluimos el fichero config.php para coger los datos de la conexión
include_once('../config.php');
//cogemos las variables de las coneción para que se puedan utilizar en el script
global $server, $database, $user, $passwd;
//abrimos la conexión
$conexion = mysql_connect($server,$user,$passwd);
//elegimos la BBDD
mysql_select_db ($database, $conexion) OR die ("No se puede conectar");

?>
<html>
<head>
<TITLE>Búsqueda de Asignaturas</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<p> Búsqueda de Asignaturas.</p>
<?php
// coloca el enlace que permite añadir un alumno
echo "<p><A HREF='nuevo.php'>Nuevo</A></p>";
// se inicia el formulario de la búsqueda
echo "<form method=\"post\" action=\"buscar.php\">";
// se indica que el campo de busqueda tiene 20 caracteres de longitud
echo "<input type=\"text\" name=\"busqueda\" size=20 maxlength =100 value=\"".$_POST['busqueda']."\">";
// se coloca el boton que se paretara para realizar la busqueda
echo "<input type=\"submit\" name=\"buscar\" value=\"Buscar\"></form><br>";
// se rellena la busqueda por todos los campos de la tabla, se debe substituir alumnos por el nombre de la tabla y poner tantos nombre_de_campo LIKE '%".$_POST['busqueda']."%' OR como campos haya.
$sql="SELECT * FROM asignaturas where nombre LIKE '%".$_POST['busqueda']."%';";
// se realiza la busqueda
$result=mysql_query($sql,$conexion);
//Se comprueba si hay resultados en la busqueda
if($row= mysql_fetch_array($result)){
// si hay resultados crea la tabla
echo "<TABLE BORDER='1'>";
//pone los campos de la tabla tiene que haber tantos <TD CLASS=\"titulo\">Nombre_de_campo</TD> como campos haya
echo "<TR><TD CLASS=\"titulo\">Nombre</TD><TD colspan=3  CLASS=\"titulo\">Opciones</TD></TR>";
//coloca las líneas de la tabla
DO
{
//aqui se ponen tantas líneas <TD width=300 CLASS=\"linea\">".$row["nombre_de_campo"]."</TD> como campos haya en la tabla
// se coloca el inicio de la fila
echo "<TR>";
//se coloca el campos del nombre
echo "<TD width=300 CLASS=\"linea\">".$row["nombre"]."</TD>";
//se colocan los enlaces de ver editar y borrar alumno
echo "<TD CLASS=\"linea\"><A HREF=ver.php?id=".$row['id'].">Ver</A></TD>";
echo "<TD width=50 CLASS=\"linea\"><A HREF=editar.php?id=".$row['id'].">Editar</A></TD>";
echo "<TD width=50 CLASS=\"linea\"><A HREF=borrar.php?id=".$row['id'].">Borrar</A></TD>";
//se termina la fila
echo "</TR>";
}
//Comprueba si se ha terminado de poner líneas
WHILE ($row=mysql_fetch_array($result));
//como se ha terminado de poner líneas se acaba la tabla
echo "</TABLE><br>";
//coloca el enlace para volver al listado
echo "<A HREF=\"index.php\">Volver</A>";
}else{
//si no hay registros que coincidan con la busqueda se le indica al usuario
echo "La búsqueda no coincide con ningún registro de la BBDD<BR>";
//se coloca el enlace del volver al listado
echo "<A HREF=\"index.php\">Volver</A>";

}
?>
</body>
</html>