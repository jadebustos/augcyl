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
$sql="Select * from matriculas WHERE id_mat=".$_GET['id'].";";
//re realiza la consulta
$result=mysql_query($sql,$conexion);
//print $sql;
//se coge el registro del alumno
$row= mysql_fetch_array($result);
?>

<html>
<head>
<TITLE>Borrar Alumno</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<?php
// se rellena la consulta que borra el alumno se substituye alumno por el nombre de la tabla 
$sql="DELETE from `matriculas` WHERE `id_mat` =".$_GET['id']." LIMIT 1 ;";
//echo $sql;
// se ejecuta la consulta se borrado
$result=mysql_query($sql,$conexion);
// se informa de que se ha eliminado un alumno
echo "<p>Matrícula eliminada</p>";
// se coloca el enlace que permite volver al listado
echo "<p><A HREF='ver_matriculas.php?id=".$_GET['id_alum']."'>Volver</A></p>";

?>
</body>
</html>