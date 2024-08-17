# git-dvd-backup

## Description
Scripts for burning git repos to a multi-session DVD  

## Prerequisites
- Xorriso

## Instructions

- Blank the DVD with a volume id in the format "$PREFIX-0000-00-00"  
  ```sh
  xorriso -dev $DEV -volid "$PREFIX"-0000-00-00 -blank
  ```
- Set `$DEV` to the cdrom device (i.e. `/dev/sr0`)  
- Set `$REPO_BASE` to the url root to clone/fetch from (i.e. `git@github.com/$ORG`)  
- Set `$VOLID_PREFIX` to the prefix to use for the volume id
- Create a repos.list file in the script root
- Run `./backup.sh`

All repos in repos.list will now be cloned/fetched, packs are created for all refs, and these are then burned into a new session on the disk, in a YYYY-MM-DD subdirectory.  
The volume ID will be updated with the current date.  
