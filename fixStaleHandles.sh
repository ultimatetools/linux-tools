#!/bin/bash

# Get list of NFS mountpoints
mapfile -t MOUNTPOINTS < <(df -h -t nfs --output=target | tail -n +2)

# Process NFS mountpoints
for m in "${MOUNTPOINTS[@]}"
do
   # Check if currently Stale File Handle
   # Example of output
   #  ls: cannot access '/tools_nfs': Stale file handle

   CHECK=$(ls $m 2>&1 > /dev/null)

   if [[ $CHECK =~ "Stale file handle" ]]; then
      echo "Fix Stale File Handle by umount & remount"
      umount -l "$m"
      sleep 2
      mount "$m"
   else
      echo "OK File Handle: $m"
   fi
done
