<?php 
//incluimos el fichero config.php para coger los datos de la conexi?n
include_once('../config.php');
//cogemos las variables de las coneci?n para que se puedan utilizar en el script
global $server, $database, $user, $passwd;
//abrimos la conexi?n
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
?>

<html>
<head>
<TITLE>Nuevo Alumno</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<?php
//se mira si se est? enviando el formulario de edici?n del alumno
if(!isset( $_POST['editar']))
{
//Si se est? enviando el formulario
//echo "<p>Vuelva a intentarlo</p>";
//se abre el formulario que envia los datos de las modificaciones de ese registro
		echo "<form method=\"post\" action=\"editar.php?id=".$_GET['id']."\" >";
// muestra el c?digo del alumno
		echo "Codigo:".$row['id']."<br>";
// a partir de aqui se muestran los campos a rellenar en el formulario
// si se substituye echo "Nombre : <input type=\"text\" name=\"nombre\" value=\"".$row['nombre']."\" maxlength =200 size=40><br>";
// por echo "Nombre : <input type=\"text\" name=\"nombre_de_campo\" value=\"".$row['nombre']."\" maxlength =longitud_maxima_de_campo size=tama?o_dte_la_caja><br>";
// se muestra la caja del nombre del alumno
		echo "Nombre : <input type=\"text\" name=\"nombre\" value=\"".$row['nombre']."\" maxlength =200 size=40><br>";
// se muestra la caja del dni
		echo "DNI : <input type=\"text\" name=\"dni\" value=\"".$row['dni']."\" maxlength =10 size=10><br>";
//inicia la combo de los tipos
echo "Tipo de Alumno:";
echo "<select name=\"tipo_de_alumno\">";
//rellena la sql para buscar las asignaturas
$sql2="Select * from tipos_de_alumno;";
//re realiza la consulta para meter en $result2 las asignaturas
$result2=mysql_query($sql2,$conexion);
//coloca en $row2 la primera asignatura
$row2= mysql_fetch_array($result2);
DO
{
//coloca la asignatura en el listado
echo "<option value=\"".$row2['id_tipo_de_alumno']."\"";
if($row2['id_tipo_de_alumno']==$row['id_tipo_de_alumno'])
	echo "selected";
echo ">".$row2['nombre']."</option>";
}
//comprueba si hay más tipos de alumno
while ($row2= mysql_fetch_array($result2));
//si no hay mas tipos de alumno cierra el listado
echo "</select> <br><br>";
// se pone el bot?n de guardar los datos
		echo "<input type=\"submit\" name=\"editar\" value=\"Guardar\"></form><br>";
}else{
// si se env?a el formulario hay que coger los datos del formulario y meterlos en la BBDD
// aqui se deben a?adir tantos isset($_POST['nombre_de_campo']) && como campos haya en la bbdd
	if(isset($_POST['nombre']) && isset($_POST['dni']) && isset($_POST['tipo_de_alumno'])){
//se desactiva el contenido de la variable $sql
		unset($sql);
// se rellena la consulta que inserta los datos
//se ponen tantos `nombre_de_campo` = '".$_POST['nombre_de_campo']."',

		$sql="UPDATE `alumnos` SET `nombre` = '".$_POST['nombre']."',`dni` = '".$_POST['dni']."',`id_tipo_de_alumno` = '".$_POST['tipo_de_alumno']."' WHERE `id` =".$_GET['id']." LIMIT 1 ;";
		//echo $sql;
		//print_r ($_POST);
//se envia la inserci?n de datos en la BBDD
		$result=mysql_query($sql,$conexion);
//Se informa por la p?gina web que el alumno ha sido modificado
		echo "<p>Alumno Modificado</p>";
//se coloca el bot?n que hace volver al listado de alumnos
		echo "<p><A HREF='index.php'>Volver</A></p>";
	}else{
	// se informa al usuario que no se han rellenado los campos
print_r($_POST);
	echo "Vuelva a intentarlo.<br>";
	//se abre el formulario que envia los datos de las modificaciones de ese registro
		echo "<form method=\"post\" action=\"editar.php?id=".$_GET['id']."\" >";
// muestra el c?digo del alumno
		echo "Codigo:".$row['id']."<br>";
// a partir de aqui se muestran los campos a rellenar en el formulario
// si se substituye echo "Nombre : <input type=\"text\" name=\"nombre\" value=\"".$row['nombre']."\" maxlength =200 size=40><br>";
// por echo "Nombre : <input type=\"text\" name=\"nombre_de_campo\" value=\"".$row['nombre']."\" maxlength =longitud_maxima_de_campo size=tama?o_dte_la_caja><br>";
// se muestra la caja del nombre del alumno
		echo "Nombre : <input type=\"text\" name=\"nombre\" value=\"".$row['nombre']."\" maxlength =200 size=40><br>";
// se muestra la caja del dni
		echo "DNI : <input type=\"text\" name=\"dni\" value=\"".$row['dni']."\" maxlength =10 size=10><br>";
// se pone el bot?n de guardar los datos
		echo "<input type=\"submit\" name=\"editar\" value=\"Guardar\"></form><br>";	
	}
}
?>
</body>
</html>