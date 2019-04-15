#/bin/bash

# script para la creacion de usuarios
# Jose Angel de Bustos Perez <jadebustos@augcyl.org>
# Modificaciones
# Pablo: Admite parametros para crea lista de usuarios

# Usuarios: usuario:uid y el uid=gid
USUARIOS="usuario1:1003 usuario2:1004"

# Nuevo uso:
# crear_usuarios <prefijo_nombre> <uid_inicial> <numero>
if [ $# -gt 2 ]
then
  USUARIOS=""
  i=0
  while [ $i -lt $3 ]
  do
    i=$[ $i + 1 ]
    num=`echo $i | sed 's/^\([1-9]\)$/0\1/'`
    uid=$[ $2 + $i ]
    USUARIOS="$USUARIOS $1$num:$uid" 
  done
fi
echo $USUARIOS

# grupos a los que perteneceran los usuarios, su grupo principal 
# sera igual que su login
GRUPOS="users"

for item in $USUARIOS
do
  user=`echo $item | sed 's/:.*//'`
  uid=`echo $item | sed 's/.*://'`
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
    useradd -md /home/$user -u $uid -g $user -G $user,$GRUPOS $user
    echo "Estableciendo password para $user:"
    passwd $user
  fi
  # forzamos cambio de password en el siguiente inicio de sesion
  chage -M 0 $user
done 
