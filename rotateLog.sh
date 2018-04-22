#!/bin/bash

#test
#test

if [ $# -lt 1 ]; then
  	echo "Usage: `basename $0` <full path and name of the file you want to rotate> "
	exit 666
fi



TODAY=`date +%Y%m%d_%H%M%S`
LOGFILEPATH=$1
LOGFILEPATHRIGHT=`stat --format=%a ${LOGFILEPATH}`
LOGFILEPATHOWNER=`stat --format=%g ${LOGFILEPATH}`
WHOAMI=`id -u`
LOGFILE=`basename ${LOGFILEPATH}`
LOGDIR=`dirname $1`
LOGFILETMP="tmp_"${LOGFILE}
ROTATELOG="rotateLog_"${LOGFILE}

#check first if the the  one who run the script is the owner
#of the file being rotate

if [[ ${LOGFILEPATHOWNER} -ne ${WHOAMI} ]] 
	then
	echo "File ${LOGFILEPATH} is not owned by you"  
	exit 666
fi

echo ">>Script START at: `date +%F_%T`" >> ${ROTATELOG}
if 
	test ! -f ${LOGFILEPATH}
		then 
			echo "File ${LOGFILEPATH} does not exist" >> ${ROTATELOG} 
			exit 666
fi

#here we rotate the file
echo "`date +%F_%T` >>Begin rotate ${LOGFILEPATH}" >> ${ROTATELOG} 
mv ${LOGFILEPATH} ${LOGDIR}"/"${TODAY}"_"${LOGFILE}

#if error then log the error and exit
if [[ $? -ne 0 ]]; then
	echo "`date +%F_%T` >>ERROR rotate ${LOGFILEPATH}" >> ${ROTATELOG}
	exit 666 
fi
echo "`date +%F_%T` >>File ${LOGFILEPATH} rotated to ${LOGDIR}"/"${TODAY}"_"${LOGFILE}" >> ${ROTATELOG} 

#create the rotated logfile
echo "This file continues from ${TODAY}"_"${LOGFILE}" > ${LOGFILEPATH}
if [[ $? -ne 0 ]]; then
	echo "`date +%F_%T` >>ERROR to create ${LOGFILEPATH}" >> ${ROTATELOG}
	exit 666 
fi
echo "`date +%F_%T` >>File ${LOGFILEPATH} recreated" >> ${ROTATELOG} 

#recreate the permision for rotated file
chmod $LOGFILEPATHRIGHT ${LOGFILEPATH}
if [[ $? -ne 0 ]]; then
	echo "`date +%F_%T` >>ERROR to recreate permision ${LOGFILEPATH}" >> ${ROTATELOG}
	exit 666 
fi
echo ">>Script END at: `date +%F_%T`" >> ${ROTATELOG}

