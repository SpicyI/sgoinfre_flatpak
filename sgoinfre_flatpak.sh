#!/bin/bash

FLATPAK_USER_PATH="/nfs/homes/$USER/.local/share/flatpak"
FLATPAK_LOCATION="/nfs/homes/$USER/.local/share"
SGOINFRE_PATH="/nfs/sgoinfre/goinfre/Perso/$USER"

DUMMY_FILENAME="/nfs/homes/$USER/.local/share/noflatpak"

check_staus() {
    echo "---> $2 , $?"
	echo -n $1
    if [ $2 ]
    then
        echo " -success-"
    else
        echo " -failure-"
        exit 1
    fi
}

check_link()
{
    if [ -L $1 ]; then
    echo "[error] flatpak directory already linked"
    exit 1
    fi
}

#check if this diractory exists
if [ -d "$DUMMY_FILENAME" ]; then
    echo "[error] dummy flatpak directory already exist plesae remove it: $DUMMY_FILENAME"
    exit 1
fi


echo "[info] attempting to copy $FLATPAK_USER_PATH to $SGOINFRE_PATH/"

check_link $FLATPAK_USER_PATH
cp -rf $FLATPAK_USER_PATH "$SGOINFRE_PATH/"
check_staus "[info] move status" $?

echo "[info] renaming  $FLATPAK_USER_PATH to  $DUMMY_FILENAME"

mv  -f $FLATPAK_USER_PATH $DUMMY_FILENAME
check_staus "[info] rename status" $?


echo "[info] linking..."

check_link $FLATPAK_USER_PATH
ln -s "$SGOINFRE_PATH/flatpak" $FLATPAK_LOCATION
check_staus "[info] linking status" $?


#updating flatpak repo

flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 
