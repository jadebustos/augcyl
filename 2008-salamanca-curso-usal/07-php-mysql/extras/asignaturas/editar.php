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
$sql="Select * from asignaturas WHERE id=".$_GET['id'].";";
//re realiza la consulta
$result=mysql_query($sql,$conexion);
//print $sql;
//se coge el registro del alumno
$row= mysql_fetch_array($result);
?>

<html>
<head>
<TITLE>Editar Asignatura</TITLE>
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
		echo "Nombre : <input type=\"text\" name=\"nombre\" value=\"".$row['nombre']."\" maxlength =100 size=40><br>";
// se pone el bot?n de guardar los datos
		echo "<input type=\"submit\" name=\"editar\" value=\"Guardar\"></form><br>";
}else{
// si se env?a el formulario hay que coger los datos del formulario y meterlos en la BBDD
// aqui se deben a?adir tantos isset($_POST['nombre_de_campo']) && como campos haya en la bbdd
	if(isset($_POST['nombre'])){
//se desactiva el contenido de la variable $sql
		unset($sql);
// se rellena la consulta que inserta los datos
//se ponen tantos `nombre_de_campo` = '".$_POST['nombre_de_campo']."',
		$sql="UPDATE `asignaturas` SET `nombre` = '".$_POST['nombre']."' WHERE `id` =".$_GET['id']." LIMIT 1 ;";
		//echo $sql;
//se envia la inserci?n de datos en la BBDD
		$result=mysql_query($sql,$conexion);
//Se informa por la p?gina web que el alumno ha sido modificado
		echo "<p>Asignatura Modificada</p>";
//se coloca el bot?n que hace volver al listado de alumnos
		echo "<p><A HREF='index.php'>Volver</A></p>";
	}else{
	// se informa al usuario que no se han rellenado los campos
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

// se pone el bot?n de guardar los datos
		echo "<input type=\"submit\" name=\"editar\" value=\"Guardar\"></form><br>";	
	}
}
?>
</body>
</html>