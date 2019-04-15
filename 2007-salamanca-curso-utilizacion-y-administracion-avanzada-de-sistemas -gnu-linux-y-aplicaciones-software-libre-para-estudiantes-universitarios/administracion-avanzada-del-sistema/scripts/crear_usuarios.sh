#/bin/bash

# script para la creacion de usuarios
# Jose Angel de Bustos Perez <jadebustos@augcyl.org>

# Usuarios: usuario:uid y el uid=gid
USUARIOS="usuario1:1003 usuario2:1004 usuario3:1016 usuario4:1018 usuario5:1019 usuario6:1020"

# grupos a los que perteneceran los usuarios, su grupo principal 
# sera igual que su login
GRUPOS="users,sysadmin"

for item in $USUARIOS
do
  user=`echo $item | awk -F':' '{print $1}'`
  uid=`echo $item | awk -F':' '{print $2}'`
  # creacion del grupo
  getent group $user > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "Creando el grupo $user ($uid) ..."
    groupadd -g $uid $user > /dev/null 2>&1
  fi
  # creacion del usuario
  getent passwd $user > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "Creando el usuario $user ($uid) ..."
    adduser -md /home/$user -u $uid -g $user -G $user,$GRUPOS $user
    echo "Estableciendo password para $user:"
    passwd $user
  fi
  # forzamos cambio de password en el siguiente inicio de sesion
  chage -M 0 $user
done 
