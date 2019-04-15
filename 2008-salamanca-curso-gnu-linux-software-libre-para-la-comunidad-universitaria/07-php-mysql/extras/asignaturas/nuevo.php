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
<TITLE>Nueva Asignatura</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>

<body>
<?php
//comprueba si se entas enviando datos para guardar
//si no es asi es que tiene que presentar el formulario
if(!isset( $_POST['nuevo']))
{
//coloca el principio del formulario para que vuelva al mismo script cuando se rellene
	echo "<form method=\"post\" action=\"nuevo.php\">";
//aqui se deben poner tantas líneas echo como campos haya
//cambiando el echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength=200 size=40><br>";
// por echo "Nombre : <input type=\"text\" name=\"nombre_campo\" maxlength=longitud_campo size=tamaño_caja_texto><br>";
//se coloca la caja de texto para el nombre
	echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength=100 size=40><br>";
////se coloca el botón de guardar
	echo "<input type=\"submit\" name=\"nuevo\" value=\"Guardar\"></form><br>";
}else{
//si se han metido los datos en el formulario
//se deben colocar tantos isset($_POST['nombre_campo']) && como campos haya en la tabla
	if(isset($_POST['nombre'])){
//en esta linea se ponen los nombres de los campos separados por comas y en la parte de values lo mismo pero con variables $_POST['nombre_campo']
		$sql="INSERT INTO `asignaturas` ( `id` , `nombre`)
		VALUES (NULL , '".$_POST['nombre']."');";
		//echo $sql;
//se ejecuta la inserción de datos
		$result=mysql_query($sql,$conexion);
//se informa de que se añadido un nueva asignatura
		echo "<p>Asignatura Añadida</p>";
//se coloca el enlace que permite volver al listado
		echo "<p><A HREF='index.php'>Volver</A></p>";
	}else{
// si no nos han metido campos
		echo "<p>Vuelva a intentarlo</p>";
// se vuelve a colocar el formulario con los mismos campos que ahora, la diferenia es que se pone tantas veces como campos haya en los VALUE el $_POST['nombre_de_campo'] para que no haya que volver a teclearlo
		echo "<form method=\"post\" action=\"nuevo.php\" >";
// se coloca la caja del nombre
		echo "Nombre : <input type=\"text\" name=\"nombre\" value=\"".$_POST['nombre']."\"  maxlength = 100 size=40><br>";
// se coloca el boton de guardar
		echo "<input type=\"submit\" name=\"nuevo\" value=\"Guardar\"></form><br>";
	}
}
?>
</body>
</html>
