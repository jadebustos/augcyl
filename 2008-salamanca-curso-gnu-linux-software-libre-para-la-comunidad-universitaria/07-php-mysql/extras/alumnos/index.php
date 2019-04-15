<?php
//incluimos el fichero config.php para coger los datos de la conexión
include_once('../config.php');
//cogemos las variables de las coneción para que se puedan utilizar en el script
global $server, $database, $user, $passwd;
//abrimos la conexión
$conexion = mysql_connect($server,$user,$passwd);
//elegimos la BBDD
mysql_select_db ($database, $conexion) OR die ("No se puede conectar");
//rellenamos la consulta, cambiar alumnos por el nombre de la tabla a listar
$sql="SELECT * FROM alumnos";
//re realiza la consulta
$result=mysql_query($sql,$conexion);

?>
<html>
<head>
<TITLE>Listado</TITLE>

<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<A href="../index.php" name="alumnos">Inicio</A><br>
<A href="index.php" name="alumnos">Alumnos</A><br>
<A href="../asignaturas/index.php" name="asignaturas">Asignaturas</A><BR>
<A href="../tipos_de_alumno/index.php" name="tipos_de_alumno">Tipos de Alumno</A><BR>
<p> Listado de Alumnos.</p>
<?php
//aqui se coloca el enlace que permite añadir un alumno
echo "<p><A HREF='nuevo.php'>Nuevo</A></p>";
//comienza el formulario que permite la busqueda
echo "<form method=\"post\" action=\"buscar.php\">";
//aqui coloca una caja de texto donde se escribe la busqueda
echo "<input type=\"text\" name=\"busqueda\" size=20 maxlength =20>";
//aqui se coloca el boton a pulsar cuando se rellene la busqueda
echo "<input type=\"submit\" name=\"buscar\" value=\"Buscar\"></form><br>";
//se cogen los primeros resultados del listado
if($row= mysql_fetch_array($result)){
//si hay algun registro inicia la tabla que muestra los resultados del listado
echo "<TABLE BORDER='1'>";
//coloca la cabecera de la tabla, aqui se substituiria con los campos de la tabla
//colocando mas <TD  CLASS=\"titulo\">campo</TD> dependiendo de los campos que haya
echo "<TR><TD CLASS=\"titulo\">Nombre</TD><TD CLASS=\"titulo\">DNI</TD><TD CLASS=\"titulo\">Tipo de Alumno</TD><TD colspan=3  
CLASS=\"titulo\">Opciones</TD></TR>";
//empieza el bucle que coloca las líneas del listado
DO
{
//Coloca una línea en el listado
//si hay mas campos se ponen más <TD width=300 CLASS=\"linea\">".$row["nombre_campo"]."</TD>
//inicia la ĺinea
echo "<TR>";
//pone el nombre del alumno
echo "<TD width=300 CLASS=\"linea\">".$row["nombre"]."</TD>";
//pone el dni del alumno
echo "<TD width=160 CLASS=\"linea\">".$row["dni"]."</TD>";

unset($result2);
unset($row2);

//rellena la sql para buscar las asignaturas
$sql2="Select * from tipos_de_alumno;";
//echo $sql2;
//re realiza la consulta para meter en $result2 las asignaturas
$result2=mysql_query($sql2,$conexion);
//echo $result2;
//coloca en $row2 la primera asignatura
$row2= mysql_fetch_array($result2);
//busca que id tiene la asignatura
DO
{
//si el nombre coincide con el elegido en el formulario coge el nombre y el id de la asignatura
if($row2['id_tipo_de_alumno']==$row['id_tipo_de_alumno']){
	//echo "hemos entrao!!";
	$nombre_tipo=$row2['nombre'];
	//echo $nombre_tipo;
	break;
}
}
//comprueba si hay más asignaturas
while ($row2= mysql_fetch_array($result2));	
//pone el dni del alumno
echo "<TD width=160 CLASS=\"linea\">".$nombre_tipo."</TD>";	
//pone los enlaces de ver, editar y borrar alumno
echo "<TD CLASS=\"linea\"><A HREF=ver.php?id=".$row['id'].">Ver</A></TD>";
echo "<TD width=50 CLASS=\"linea\"><A HREF=editar.php?id=".$row['id'].">Editar</A></TD>";
echo "<TD width=50 CLASS=\"linea\"><A HREF=borrar.php?id=".$row['id'].">Borrar</A></TD>";
//termina la fila
echo "</TR>";
}
//comprueba si hay mas registros que colocar
WHILE ($row=mysql_fetch_array($result));
//si no hay mas registros termina la tabla
echo "</TABLE><br>";
//coloca el enlace que permite volver a listar
echo "<A HREF=\"index.php\">Volver</A>";
}else{
//si no hay registros en la tabla informa de ello
echo "No hay ning&uacute;n alumno en la BBDD<BR>";
//coloca el enlace que permite volver a listar
echo "<A HREF=\"index.php\">Volver</A>";

}
//termina el script
?>
</body>
</html>