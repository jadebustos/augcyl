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
//print $sql;
//re realiza la consulta
$result=mysql_query($sql,$conexion);
//mete el alumno en la variable $row
$row= mysql_fetch_array($result);

//print $sql2;
?>

<html>
<head>
<TITLE>Matricular Alumno:<?php echo $row['nombre']; ?></TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<?php
//comprueba si se entas enviando datos para guardar
//si no es asi es que tiene que presentar el formulario
if(!isset( $_POST['nuevo']))
{
//coloca el principio del formulario para que vuelva al mismo script cuando se rellene
	echo "<form method=\"post\" action=\"matricular.php?id=".$_GET['id']."\">";
//aqui se deben poner tantas líneas echo como campos haya
//cambiando el echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength=200 size=40><br>";
// por echo "Nombre : <input type=\"text\" name=\"nombre_campo\" maxlength=longitud_campo size=tamaño_caja_texto><br>";
//se muestra el código del alumno
echo "<p>Código:".$row["id"]."</p>";
//se muestra el nombre del alumno
echo "<p>Nombre:".$row["nombre"]."</p>";
	
//se coloca la caja oculta con el id del alumno
	echo "<input type=\"hidden\" name=\"id_alum\" value=\"".$row['id']."\">";
//inicia la combo de las asignaturas
echo "<select name=\"asignatura\">";
//rellena la sql para buscar las asignaturas
$sql2="Select * from asignaturas;";
//re realiza la consulta para meter en $result2 las asignaturas
$result2=mysql_query($sql2,$conexion);
//coloca en $row2 la primera asignatura
$row2= mysql_fetch_array($result2);
DO
{
//coloca la asignatura en el listado
echo "<option value=\"".$row2['id']."\">".$row2['nombre']."</option>";
}
//comprueba si hay más asignaturas
while ($row2= mysql_fetch_array($result2));
//si no hay mas asignatutas cierra el listado de asignaturas
echo "</select> <br><br>";
////se coloca el botón de guardar
	echo "<input type=\"submit\" name=\"nuevo\" value=\"Guardar\"></form><br>";
}else{
//si se han metido los datos en el formulario
//se deben colocar tantos isset($_POST['nombre_campo']) && como campos haya en la tabla
	if(isset($_POST['id_alum']) && isset($_POST['asignatura'])){

//se reinician las variables de la busqueda
unset($result2);
unset($row2);

//rellena la sql para buscar las asignaturas
$sql2="Select * from asignaturas;";
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
if($row2['id']==$_POST['asignatura']){
	//echo "hemos entrao!!";
	$nombre_asig=$row2['nombre'];
	//echo $nombre_asig;
	$id_asig=$row2['id'];
	//echo $id_asig;
	break;
}
}
//comprueba si hay más asignaturas
while ($row2= mysql_fetch_array($result2));


		$sql="INSERT INTO `matriculas` ( `id_mat` , `id_alum` , `id_asig` )
		VALUES (NULL , ".$_POST['id_alum']." , ".$_POST['asignatura'].")";
		//echo $sql;
//se ejecuta la inserción de datos
		$result=mysql_query($sql,$conexion);
//se informa de que se añadido un nuevo alumno
		echo "<p>Matrícula añadida del alumno ".$row['nombre']." en la asignatura ".$nombre_asig."</p>";
//se coloca el enlace que permite volver al listado
		echo "<p><A HREF='ver_matriculas.php?id=".$_GET['id']."'>Volver</A></p>";
	}else{
// si no nos han metido campos
		echo "<p>Vuelva a intentarlo</p>";
// se vuelve a colocar el formulario con los mismos campos que ahora, la diferenia es que se pone tantas veces como campos haya en los VALUE el $_POST['nombre_de_campo'] para que no haya que volver a teclearlo
	echo "<form method=\"post\" action=\"matricular.php\">";
//aqui se deben poner tantas líneas echo como campos haya
//cambiando el echo "Nombre : <input type=\"text\" name=\"nombre\" maxlength=200 size=40><br>";
// por echo "Nombre : <input type=\"text\" name=\"nombre_campo\" maxlength=longitud_campo size=tamaño_caja_texto><br>";
//se muestra el código del alumno
echo "<p>Código:".$row["id"]."</p>";
//se muestra el nombre del alumno
echo "<p>Nombre:".$row["nombre"]."</p>";
	
//se coloca la caja oculta con el id del alumno
	echo "id : <input type=\"hidden\" name=\"id_alum\" value=\"".$row['id']."\"><br>";
//inicia la combo de las signaturas
echo "<select name=\"asignatura\">";
//rellena la sql para buscar las asignaturas
$sql2="Select * from asignaturas;";
//re realiza la consulta para meter en $result2 las asignaturas
$result2=mysql_query($sql2,$conexion);
//coloca en $row2 la primera asignatura
$row2= mysql_fetch_array($result2);
DO
{
//coloca la asignatura en el listado
echo "<option>".$row2['nombre']."</option>";
}
//comprueba si hay más asignaturas
while ($row2= mysql_fetch_array($result2));
//si no hay mas asignatutas cierra el listado de asignaturas
echo "</select> ";
////se coloca el botón de guardar
	echo "<input type=\"submit\" name=\"nuevo\" value=\"Guardar\"></form><br>";
	}
}
?>
</body>
</html>