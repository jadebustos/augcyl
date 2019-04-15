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
<TITLE>Nuevo Alumno</TITLE>
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
// se muestra la caja del nombre del alumno
		echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength =100 size=40><br>";
// se muestra la caja del dni del alumno
		echo "DNI : <input type=\"text\" name=\"dni\" maxlength =15 size=9><br>";
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
echo "<option value=\"".$row2['id_tipo_de_alumno']."\">".$row2['nombre']."</option>";
}
//comprueba si hay más tipos de alumno
while ($row2= mysql_fetch_array($result2));
//si no hay mas tipos de alumno cierra el listado
echo "</select> <br><br>";
////se coloca el botón de guardar
	echo "<input type=\"submit\" name=\"nuevo\" value=\"Guardar\"></form><br>";
}else{
//si se han metido los datos en el formulario
//se deben colocar tantos isset($_POST['nombre_campo']) && como campos haya en la tabla
	if(isset($_POST['nombre']) && isset($_POST['dni']) &&  isset($_POST['tipo_de_alumno'])){
//en esta linea se ponen los nombres de los campos separados por comas y en la parte de values lo mismo pero con variables $_POST['nombre_campo']
//se reinician las variables de la busqueda
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
if($row2['id_tipo_de_alumno']==$_POST['tipo_de_alumno']){
	//echo "hemos entrao!!";
	$nombre_asig=$row2['nombre'];
	//echo $nombre_asig;
	$id_tipo_de_alumno=$row2['id_tipo_de_alumno'];
	//echo $id_asig;
	break;
}
}
//comprueba si hay más asignaturas
while ($row2= mysql_fetch_array($result2));		
$sql="INSERT INTO `alumnos` ( `id` , `nombre` , `dni`, `id_tipo_de_alumno` )
		VALUES (NULL , '".$_POST['nombre']."' , '".$_POST['dni']."', '".$id_tipo_de_alumno."');";
		//echo $sql;
//se ejecuta la inserción de datos
		$result=mysql_query($sql,$conexion);
//se informa de que se añadido un nuevo alumno
		echo "<p>Alumno Añadido</p>";
//se coloca el enlace que permite volver al listado
		echo "<p><A HREF='index.php'>Volver</A></p>";
	}else{
// si no nos han metido campos
		echo "<p>Vuelva a intentarlo</p>";
// se vuelve a colocar el formulario con los mismos campos que ahora, la diferenia es que se pone tantas veces como campos haya en los VALUE el $_POST['nombre_de_campo'] para que no haya que volver a teclearlo
	
	echo "<form method=\"post\" action=\"nuevo.php?id=".$_GET['id']."\">";
//aqui se deben poner tantas líneas echo como campos haya
//cambiando el echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength=200 size=40><br>";
// por echo "Nombre : <input type=\"text\" name=\"nombre_campo\" maxlength=longitud_campo size=tamaño_caja_texto><br>";
// se muestra la caja del nombre del alumno
		echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength =100 size=40><br>";
// se muestra la caja del dni del alumno
		echo "DNI : <input type=\"text\" name=\"nombre\" maxlength =15 size=9><br>";
//inicia la combo de los tipos
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
echo "<option value=\"".$row2['id_tipo_de_alumno']."\">".$row2['nombre']."</option>";
}
//comprueba si hay más tipos de alumno
while ($row2= mysql_fetch_array($result2));
//si no hay mas tipos de alumno cierra el listado
echo "</select> <br><br>";
////se coloca el botón de guardar
	echo "<input type=\"submit\" name=\"nuevo\" value=\"Guardar\"></form><br>";
	}
}
?>
</body>
</html>
