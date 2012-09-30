# functions.sh: LCARS theme on Linux DE for LCARchS.

# VERSION: 01-g3mx-alpha: GTK, GDM, Gnome, Metacity, Xfce4
# AUTHOR: Joseph Edwards <github.com:joseph8th/lcars_gx.git>

# Settings in 'lcars.conf' file:

#### Helper functions ####

# usage function for getopts() 
usage() 
{
cat << EOF

USAGE: $0 options [elements]

DESCRIPTION: LCARchS is a Star Trek fan LCARS desktop theme utility for Linux.
This version (gx02) optimized for Arch Linux with Xfce4/GTK and GDM splashpage. 

OPTIONS (choose one):
  -h  Show this message
  -i  Install a theme element
  -r  Remove a theme element

MODIFIERS (optional):
  -x  Choose DE/WM
  -a  Activate after install

ENVIRONMENT (DE/WM) flags (optional):
  xfce  Xfce4
  g2    GNOME2
  meta  Metacity (Nautilus)
  (*)   Default: "xfce"

ELEMENTS:
  all    All elements 
  dbg    Desktop background
  gdm    GDM splash screen
  theme  GTK theme
  sound  Alert sound
  conky  Conky configs

NOTES:
  * Quote multiple elements or enviornments.
  * Expect root access password request.

EXAMPLES:

* Install and attempt to activate background and gdm themes
  for Xfce4 and GNOME2:

  $ lcarchs -i "dbg gdm" -x "xfce g2" -a

* Remove and restore (activate removal) of conky config:

  $ lcarchs -r conky -a
EOF
}


# Sudo mkdir used if dir structure is new
_mk_dir()
{
    printf "Really mkdir %s ? (y/n): " "$1"
    read ans
    [ $ans == "y" ] && mkdir "$1" && return 0 || return 1
}


# Sudo mkdir used if dir structure is new
_smk_dir()
{
    printf "Really sudo mkdir %s ? (y/n): " "$1"
    read ans
    [ $ans == "y" ] && sudo mkdir "$1" && return 0 || return 1
}



# Function to check if array contains element
contains_elt() {
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}


#### GLOBAL VARIABLES ####

ELTLIST=( dbg gdm theme sound conky )
XLIST=( xfce g2 meta )


# Function to update .config/$LCARS directories
_updateconf() {

    local workdir=$LCARS_HOME
    declare -a local pkg=( )

    echo "Updating your $LCARS config files..."
    case "$1" in
        dbg)
            workdir=${workdir}${MY_BGS}
            [ ! -f  "${workdir}/${LCARS_BG}" ] && pkg=("$PKG_BG")
            ;;
        gdm)
            workdir=${workdir}${MY_BGS}
            [ ! -f  "${workdir}/${LCARS_LOGIN_BG}" ] && pkg=("$PKG_LOGIN_BG")
            ;;
        theme)
            workdir=${workdir}${MY_THEMES}
            [ ! -f "${workdir}/${LCARS_THEME}" ] && pkg=("$PKG_THEME")
            if $(contains_elt  "meta" "$MY_XENV"); then
                if [ ! -f "${workdir}/${LCARS_METACITY}" ]; then 
                    pkg=("${pkg[@]}" "$PKG_METACITY")
                fi
            fi
            ;;
        sound)
            workdir=${LCARS_HOME}${MY_SOUNDS}
            [ ! -f "${workdir}/${LCARS_THEME}" ] && pkg=("$PKG_SOUND")
            ;;
        conky)
            workdir=${LCARS_HOME}${LCARS_CONFD}${LCARS_CONKY}
            if [ ! -d "$workdir" ]; then
                _mk_dir "$workdir"
                [ "$?" == 1 ] && exit 1
            fi
            if [ ! -f "${workdir}/.config" ]; then
                pkg=("${PKG_CONKY[@]}")
            fi
            ;;
    esac

    for p in "${pkg[@]}"
    do
        printf "==> Copying:\t%s\n\t-->\t%s\n" "$p" "$workdir"
        cp $p $workdir
    done
}



#### Remove function ####
lcars_remove() 
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        echo "==> Removing ${elt} for ${x}..."
    done
}

lcars_restore()
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        echo "==> Attempting to restore ${elt}..."
    done
}


### Install function ###
lcars_install() 
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        echo "==> Installing ${elt}..."
        _install $elt
    done
}

lcars_activate()
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        echo "==> Attempting to activate ${elt}..."
    done
}


# Install config'd files to LCARS_SHARE 
# + link to MY_SHARE sibling dirs
_install()
{
    # Update configurable files folders for given $elt
    _updateconf $1

    case "$1" in
        dbg)
            # Background install 
            work_dir=${MY_SHARE}${MY_BGS}
            if [ ! -d "${work_dir}/${LCARS}" ]; then
	        echo "LCARS backgrounds not installed..."
                echo "==> Creating: ${workdir}/${LCARS}"
	        _smk_dir ${work_dir}/${LCARS}
                [ "$?" == 1 ] && exit 1
            fi
            # Copy config'd files to usr/share
            printf "==> Copying:\t%s%s/*\n\t-->\t%s\n" "$LCARS_HOME" "$MY_BGS" "${work_dir}/${LCARS}/"
	    sudo cp ${LCARS_HOME}${MY_BGS}/* ${work_dir}/${LCARS}/
            ;;
            # Enable for Linux Mint above ';;' ^^^^^
#            ln -sf ${work_dir}/${LCARS}/${LCARS_BG} ${work_dir}${MY_DEFAULT_BG}

        theme)
            # Default Install LCARS-GTK-2.0 desktop theme
            work_dir=${MY_SHARE}${MY_THEMES}
            if [ ! -d "${work_dir}/LCARS-GTK" ]; then
                echo "LCARS-GTK desktop theme not installed..."
                printf "Extracting %s to %s%s.\n" $LCARS_THEME $MY_SHARE $MY_THEMES
                sudo tar -xvfz ${LCARS_HOME}${MY_THEMES}/${LCARS_THEME} -C $work_dir
                sudo chmod 755 ${work_dir}/LCARS-GTK/gtk-2.0/gtkrc
            else
                echo "LCARS-GTK theme already installed."
            fi

            # Install LCARS-Desktop Gnome's Nautilus/Metacity window mngr theme
            if $(contains_elt "meta" "$MY_XENV"); then
                if [ ! -d "$work_dir/LCARS-Desktop" ]; then
                    echo "LCARS-Desktop Metacity theme not installed..."
                    printf "Extracting %s to %s%s.\n" $LCARS_THEME $MY_SHARE $MY_THEMES
                    sudo tar -zxvf ${LCARS_HOME}${MY_THEMES}/${LCARS_METACITY} -C $work_dir
                    sudo chmod 755 $work_dir/LCARS-Desktop/index.theme
                else
                    echo "LCARS-Desktop theme already installed."
                fi
            fi
            ;;

        sound)
            # Install LCARS defaultsound.wav as login sound
            work_dir=${MY_SHARE}${MY_SOUNDS}
            if [ ! -d "${work_dir}/${LCARS}" ]; then
                echo "LCARS sounds not installed..."
                echo "==> Creating: ${workdir}/${LCARS}"
                _smk_dir ${work_dir}/${LCARS}
                [ "$?" == 1 ] && exit 1
            fi
            # Copy config'd files to usr/share
            sudo cp ${LCARS_HOME}${MY_SOUNDS}/* ${work_dir}/${LCARS}/
            ;;

        conky)
            # Setup and configure Conky for LCARS-GX.
            # Check to see that qiv is installed, else exit.
            if [ $(qiv -v) == "bash: qiv: command not found" ]; then
                echo "LCARchS conky requires 'qiv' (Quick Image Viewer)."
                echo "Install with pacman, apt-get, etc. then try again."
                exit 1
            fi
            if [ -f ${MY_HOME}/.conkyrc ]; then
                echo "You must mv your old '~/.conkyrc' to a new name before installing."
            else
                echo "No ~/.conkyrc found. (Re)installing Conky configuration."
                echo "Installing ${LCARS_SHARE}/conky_delay_start script."
                echo "Add this to your Startup settings to activate on startup."
                sudo cp ${LCARS_HOME}${LCARS_CONFD}${LCARS_CONKY}/conky_delay_start ${LCARS_SHARE}/
                sudo chmod 755 ${LCARS_SHARE}/conky_delay_start
            fi
            ;;
    esac
}

_activate() {

    case "$1" in
        conky)
            echo "Activating conky!"
            source ${LCARS_SHARE}/conky_delay_start
            ;;
    esac

}
