#!/bin/bash

# Install LCARS on Linux Mint distros
# Author: Joseph Edwards <github.com:joseph8th/lcars_gx.git>

# Settings in 'lcarsrc' file:
#
# LCARS_HOME
# LCARS_SHARE            MY_USR_SHARE_DIR       
# LCARS_GTK_THEME        MY_GTK_THEMES_DIR      
# LCARS_FONTS            MY_FONTS_DIR           
# LCARS_BACKGROUND       MY_BACKGROUNDS_DIR     
# LCARS_METACITY

source lcarsrc.sh

# Install (copy) background (wallpaper) into a shared location
if [ "$1" = "bg" ]; then
    work_dir=${MY_USR_SHARE_DIR}${MY_BACKGROUNDS_DIR}
    if [ ! -d "$work_dir/lcars_gx" ]; then
	echo "LCARS backgrounds not installed... attempting installation."
        echo "Activate your background under Desktop settings."
	mkdir $work_dir/lcars_gx
    fi
    if [ -d "$work_dir/lcars_gx" ]; then
	cp ./backgrounds/${LCARS_BACKGROUND} $work_dir/lcars_gx/
	cp ./backgrounds/${LCARS_LOGIN_BG} $work_dir/lcars_gx/
        ln -sf ${work_dir}/lcars_gx/${LCARS_LOGIN_BG} ${work_dir}${MY_DEFAULT_BG}
    fi
fi

# Install LCARS-GTK-2.0 desktop theme
if [ "$1" = "gtk" ]; then
    work_dir=${MY_USR_SHARE_DIR}${MY_GTK_THEMES_DIR}
    if [ ! -d "$work_dir/LCARS-GTK" ]; then
        echo "LCARS-GTK desktop theme not installed... attempting installation."
        echo "Activate the theme in Appearance settings."
        printf "Extracting %s to %s%s.\n" $LCARS_GTK_THEME $MY_USR_SHARE_DIR $MY_GTK_THEMES_DIR
        tar -zxvf ./themes/${LCARS_GTK_THEME} -C $work_dir
        chmod 755 $work_dir/LCARS-GTK/gtk-2.0/gtkrc
    else
        echo "LCARS-GTK theme already installed."
    fi
fi

# NOT DONE! NOTHING SET IN SETTINGS FOR THIS!
# Install LCARS-Desktop Gnome's Nautilus/Metacity window mngr theme
if [ "$1" = "gnome" ]; then
    work_dir=${MY_USR_SHARE_DIR}${MY_GTK_THEME_DIR}
    if [ ! -d "$work_dir/LCARS-Desktop" ]; then
        echo "LCARS-Desktop windows theme not installed... attempting installation."
        echo "Activate the theme in Window decoration settings."
        printf "Extracting %s to %s%s.\n" $LCARS_GTK_THEME $MY_USR_SHARE_DIR $MY_GTK_THEMES_DIR
        tar -zxvf ./themes/${LCARS_METACITY} -C $work_dir
        chmod 755 $work_dir/gtkrc
    else
        echo "LCARS-GTK theme already installed."
    fi
fi

# Setup and configure Conky for LCARS-GX.
if [ "$1" = "conky" ]; then
    if [ -f $MY_HOME/.conkyrc ]; then
        echo "You must mv your old '~/.conkyrc' to a new name before installing."
    else
        echo "No ~/.conkyrc found. Installing new Conky configuration file."
        printf "Any LCARS-GX specific files will be overwritten if they exist.\n"
        cp ./settings/conkyrc $MY_HOME/.conkyrc

        if [ ! -d ${LCARS_HOME} ]; then
            echo "No ${LCARS_HOME} found. mkdir-ing new LCARS-GX config folder."
            mkdir $LCARS_HOME
        fi
        echo "Installing ${LCARS_HOME}/.conkyrc_logs."
        printf "Customize the LOGS settings in this file to suit your system.\n"
        cp ./settings/conkyrc_logs ${LCARS_HOME}/.conkyrc_logs

        if [ ! -d ${LCARS_SHARE} ]; then
            printf "No ${LCARS_SHARE} found. mkdir-ing new startup script folder."
            mkdir $LCARS_SHARE
        fi
        echo "Installing ${LCARS_SHARE}/conky_delay_start script."
        echo "Add this to your Startup settings to activate on startup."
        cp ./scripts/conky_delay_start ${LCARS_SHARE}/
        cp ./lcarsrc.sh ${LCARS_SHARE}/lcarsrc
        chmod 755 ${LCARS_SHARE}/conky_delay_start
        chmod 755 ${LCARS_SHARE}/lcarsrc
    fi
fi

exit 0