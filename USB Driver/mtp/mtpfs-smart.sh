#!/bin/bash

##############################################################
MTP_DRIVE="Media Driver"
USB_DRIVE="USB Driver"
DEFAULT_CDROM="ZTECdrom"
##############################################################

echo "mtp begin"
GVFSMTPM=gvfs-mtp-volume-monitor
if [ "$1" = "add" ]; then
 pid=`ps aux |grep simple-mtpfs |grep -vn grep|awk '{print $2}'`
 if [ -z $pid ]; then
	echo "mtp add..." 
        if [ -f "/usr/libexec/$GVFSMTPM" ]; then
           mv /usr/libexec/$GVFSMTPM /usr/local/
        fi 
        
        if [ -f "/usr/lib/gvfs/$GVFSMTPM" ]; then
           mv /usr/lib/gvfs/$GVFSMTPM /usr/local/
        fi 

        ps -ef |grep gvfs-mtp |grep -vn "grep" |awk '{print $2}'| xargs kill -9
#        ps -ef |grep gvfs-gphoto2-volume-monitor |grep -vn "grep" |awk '{print $2}'| xargs kill -9
        pid=`ps aux |grep gvfsd-mtp|grep -vn grep|awk '{print $2}'`
        if [ -z $pid ];then
            kill -9 $pid 
        fi


	if [ ! -d  "/media/$MTP_DRIVE" ]; then
             echo "create dir /media/Media Driver"
	       /bin/mkdir   "/media/$MTP_DRIVE" 
	fi 
	
        if [ ! -d "/media/$MTP_DRIVE" ]; then
             echo "failed to create /media/Media Driver"
        else
             echo "create /media/Media Driver success"
        fi         
      
	  /bin/chmod  777  "/media/$MTP_DRIVE"   

	line_num=`ls /dev/libmtp* 2>/dev/null | wc -l`
    if [ $line_num -ne 0 ]; then
           
             echo "mtpfs mount.."
	     /usr/bin/mtpclient add
           
    fi

  fi
elif [ "$1" = "remove" ]; then
	echo "mtp remove..."
	/bin/umount  "/media/$MTP_DRIVE"  
        if [ -f "/usr/local/$GVFSMTPM" ]; then
            mv /usr/local/$GVFSMTPM /usr/lib/gvfs/
        fi
       
        pid=`ps aux |grep gvfs-mtp-volume-monitor |grep -vn grep|awk '{print $2}'`
        if [ -z $pid ];then
            /usr/bin/mtpclient remove
        fi
	
        if [ -d  "/media/$MTP_DRIVE" ]; then
		/bin/rm -rf   "/media/$MTP_DRIVE" 
	fi  
elif [ "$1" = "mount" ]; then
	echo "USB Driver mount..."
	/bin/umount                          "/media/$USB_DRIVE"
	/bin/mkdir                           "/media/$USB_DRIVE"
	/bin/mount  "/dev/$DEFAULT_CDROM"    "/media/$USB_DRIVE"
else
	#echo "invalid parameter"
	exit 1
fi

exit 0
##############################################################
