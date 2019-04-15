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
$sql="Select * from alumnos WHERE id=".$_GET['id'].";";
//re realiza la consulta
$result=mysql_query($sql,$conexion);
//print $sql;
//se coge el registro del alumno
$row= mysql_fetch_array($result);
//rellenamos la consulta, para ver las matriculaciones del alumno
$sql2="Select * from matriculas WHERE id_alum=".$_GET['id'].";";
//echo $sql2;
//re realiza la consulta
$result2=mysql_query($sql2,$conexion);


?>

<html>
<head>
<TITLE>Matrículas de <?php echo $row['nombre']; ?></TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<?php
//en esta parte se muestran los campos básicos del alumno
//se muestra el código del alumno
echo "<p>Código:".$row["id"]."</p>";
//se muestra el nombre del alumno
echo "<p>Nombre:".$row["nombre"]."</p>";

echo "<p><A HREF='matricular.php?id=".$_GET['id']."'>Nueva matrícula</A></p>";
if($row2= mysql_fetch_array($result2)){
//se muestra que se estan listando matriculas
echo "<p>Listado de Matrículas</p>";
//si hay algun registro inicia la tabla que muestra los resultados del listado
echo "<TABLE BORDER='1'>";
//coloca la cabecera de la tabla, aqui se substituiria con los campos de la tabla
//colocando mas <TD  CLASS=\"titulo\">campo</TD> dependiendo de los campos que haya
echo "<TR><TD CLASS=\"titulo\">Asignatura</TD><TD CLASS=\"titulo\">Opcion</TD></TR>";
//empieza el bucle que coloca las líneas del listado
DO
{
//Coloca una línea en el listado
//si hay mas campos se ponen más <TD width=300 CLASS=\"linea\">".$row["nombre_campo"]."</TD>
//inicia la ĺinea
echo "<TR>";
//rellenamos la consulta, para ver las matriculaciones del alumno
$sql3="Select * from asignaturas WHERE id=".$row2['id_asig'].";";
//echo $sql3;
//re realiza la consulta
$result3=mysql_query($sql3,$conexion);
$row3= mysql_fetch_array($result3);
echo "<TD width=300 CLASS=\"linea\">".$row3["nombre"]."</TD>";
//pone los enlaces de ver, editar y borrar alumno
echo "<TD width=50 CLASS=\"linea\"><A HREF=borrar_matricula.php?id=".$row2['id_mat']."&id_alum=".$_GET['id'].">Borrar Matrícula</A></TD>";
//termina la fila
echo "</TR>";
//limpiamos la $sql3
unset($sql3);
}
//comprueba si hay mas registros que colocar
WHILE ($row2=mysql_fetch_array($result2));
//si no hay mas registros termina la tabla
echo "</TABLE><br>";

}else {

echo "No hay matrículas para este alumno";
}
// se coloca el enlace para ir a la vista de ver alumno
echo "<p><A HREF='index.php'>Volver a ver alumno</A></p>";
?>
</body>
</html>