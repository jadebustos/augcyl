# Nombre del ordenador
COMPUTER=merc                         

# Directorios de los que quieres hacer backup
DIRECTORIES="/home /etc /root /var/www"

# Donde almacenar los backups
BACKUPDIR=/backups           

# Fecha del ultimo backup completo
TIMEDIR=/backups/last-full  

# Nombre y path de la utilidad tar
TAR=/bin/tar                      
             
# Fichero de patrones de exclusion
EXC="-X $BACKUPDIR/exclude.txt"

PATH=/usr/local/bin:/usr/bin:/bin
# D?a de la semana, p.ej Mon
DOW=`date +%a`           

# D?a del mes, p.ej 27            
DOM=`date +%d`           

# D?a y Mes e.g. 27Sep
DM=`date +%d%b`             

ls -laR $DIRECTORIES > $BACKUPDIR/lslaR-$DM.txt
# El d?a 1 de cada mes se hace un backup completo que se
# sobrescribe el d?a 1 del mes siguiente
# Cada domingo se hace un backup completo, sobrescribiendo
# el backup del domingo anterior
# El resto de los d?as se hace un backup incremental
#

# Backup completo de cada mes
if [ $DOM = "01" ]; then
       NEWER=""
       $TAR $NEWER $EXC -czf $BACKUPDIR/$COMPUTER-$DM.tar.gz $BACKUPDIR/lslaR-$DM.txt $DIRECTORIES
fi

# Backup completo de cada semana
if [ $DOW = "Sat" ]; then
       NEWER=""
       NOW=`date +%d-%b`

       # Update full backup date
       echo $NOW > $TIMEDIR/$COMPUTER-full-date
       $TAR $NEWER $EXC -czf $BACKUPDIR/$COMPUTER-$DOW.tar.gz $BACKUPDIR/lslaR-$DM.txt $DIRECTORIES
else
# Backup incremental de cada d?a
       # Obtenemos la fecha del ?ltimo backup completo
       if [ -x $TIMEDIR/$COMPUTER-full-date ]; then
       	  NEWER="--newer `cat $TIMEDIR/$COMPUTER-full-date`"
       fi
       $TAR $NEWER $EXC -czf $BACKUPDIR/$COMPUTER-$DOW.tar.gz $BACKUPDIR/lslaR-$DM.txt $DIRECTORIES
fi
