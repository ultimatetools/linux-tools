#!/bin/bash

# Get list of NFS mountpoints
#LIST=$(df -HP -t nfs | tail -n +2)
#mapfile -t MOUNTPOINTS < <(df -HP -t nfs | tail -n +2)
mapfile -t MOUNTPOINTS < <(df -h -t nfs --output=target | tail -n +2)

# mount -l -t nfs
# cat /proc/mounts | grep nfs

# Process elements
for m in "${MOUNTPOINTS[@]}"
do
   # Check if currently Stale File Handle
   #   ls: cannot access '/tools_nfs': Stale file handle
   #CHECK=`ls $m`
   CHECK=$(ls $m 2>&1 > /dev/null)

   #echo $CHECK

   if [[ $CHECK =~ "Stale file handle" ]]; then
      echo "Stale File Handle: $m"
      echo "Fix by umount & remount"
      umount -l "$m"
      sleep 2
      mount "$m"
   else
      echo "OK File Handle: $m"
   fi
done
