#!/bin/bash

# A source-able settings file for customization
# used by 'install' for LCARS GX theme-ing.

#### USER SETTINGS (compat systems should OK) ####

MY_USR_SHARE_DIR="/usr/share"

# Shared theme elements install - sudo req
MY_GTK_THEMES_DIR="/themes"
MY_FONTS_DIR="/fonts/truetype"
MY_BACKGROUNDS_DIR="/backgrounds"


#### RECOMMENDED SETTINGS ####

# these folders will be created or used
LCARS_HOME="${HOME}/.lcars_gx"
LCARS_SHARE="/usr/share/lcars_gx"

# location of files to install - rel to this script
LCARS_FONTS="lcarsfont.zip"
LCARS_BACKGROUND="default_lcars_gx.jpg"
LCARS_GTK_THEME="LCARS-GTK-1.2.tar.gz"
