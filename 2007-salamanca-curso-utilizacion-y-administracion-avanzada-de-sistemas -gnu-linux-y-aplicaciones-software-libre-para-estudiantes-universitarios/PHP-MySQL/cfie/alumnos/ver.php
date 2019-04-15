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
?>

<html>
<head>
<TITLE>Alumno:<?php echo $row['nombre']; ?></TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../estilo.css">
</head>
<body>
<?php
//en esta parte se muestran los campos del alumno
//se debe añadir líneas tantas como campos tenga la tabla: echo "<p>Nombre de campo:".$row["nombre_de_campo"]."</p>";
//se muestra el código del alumno
echo "<p>Código:".$row["id"]."</p>";
//se muestra el nombre del alumno
echo "<p>Nombre:".$row["nombre"]."</p>";
//se muestra el dni del alumno
echo "<p>DNI:".$row["dni"]."</p>";
$sql2="Select * from tipos_de_alumno where id_tipo_de_alumno=".$row['id_tipo_de_alumno'].";";
//echo $sql2;
//re realiza la consulta para meter en $result2 los tipos de alumnos
$result2=mysql_query($sql2,$conexion);
//coloca en $row2 el primer tipo de alumno
$row2= mysql_fetch_array($result2);
echo "<p>Tipo de Alumno:".$row2["nombre"]."</p>";
//se coloca el enlace para que pueda editarse el alumno.
echo "<p><A HREF=editar.php?id=".$row['id'].">Editar</A></TD></p>";
// se coloca el enlace para borrar el alumno
echo "<p><A HREF=borrar.php?id=".$row['id'].">Borrar</A></TD></p>";
// se coloca el enlace para ver la matriculas de alumno
echo "<p><A HREF=ver_matriculas.php?id=".$row['id'].">Ver Matriculas</A></TD></p>";
// se coloca el enlace para ir a listado de alumnos
echo "<p><A HREF='index.php'>Atras</A></p>";
?>
</body>
</html>