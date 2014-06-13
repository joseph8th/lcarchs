# functions.sh: functions supporting LCARchS theming utility

# VERSION: 0.3gx (alpha): GTK, Gnome2, Xfce4, XDM
# AUTHOR: Joseph Edwards (joseph8th@urcomics.com)

# Settings in 'lcars.conf' file:

#### Helper functions ####

# usage function for getopts() 
usage() 
{
cat << EOF

USAGE: $0 options [elements]

DESCRIPTION: LCARchS is a Star Trek fan LCARS desktop theming utility for Linux.
This version (0.4) optimized for Arch Linux with Xfce4/GTK and XDM login manager.

This version is little more than an installer. Activation is up to the user. Expect root access password request.
 
  * GTK and Gnome2/Metacity theme elements.
  * Desktop background (1280x800) optimized for use with Conky system monitor.
  * Conky configuration optimized for included background (Conky and qiv required).
  * XDM login screen theme elements.
  * Alert sound file (wav).
  * Multipurpose icon.


(!) Options marked with (!) are in development and non-operative in this version.

OPTIONS (choose one):
  -h  Show this message
  -i  Install a theme element
  -r  Remove a theme element (!)

MODIFIERS (optional):
  -x  Choose DE/WM
  -a  Activate after install (!)

ENVIRONMENT (DE/WM) flags (optional):
  xfce  Xfce4
  g2    GNOME2
  meta  Metacity (Compiz)
  (*)   Default: "xfce"

ELEMENTS:
  all    All elements 
  dbg    Desktop background
  xdm    XDM login screen (!)
  theme  GTK theme
  sound  Alert sound
  conky  Conky configs
  icon   Multipurpose icon


EXAMPLES:

* Install background and sound files (for Xfce4 and GNOME2):

  $ lcarchs -i "dbg sound" -x "xfce g2"

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

ELTLIST=( dbg gdm theme sound conky icon )
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
            workdir=${workdir}${MY_SOUNDS}
            [ ! -f "${workdir}/${LCARS_SOUND}" ] && pkg=("$PKG_SOUND")
            ;;
        icon)
            workdir=${workdir}${MY_ICONS}
            [ ! -f "${workdir}/${LCARS_ICON}" ] && pkg=("$PKG_ICON")
            ;;
        conky)
            workdir=${workdir}${LCARS_CONFD}${LCARS_CONKY}
            if [ ! -d "$workdir" ]; then
                _mk_dir "$workdir"
                [ "$?" == 1 ] && exit 1
            fi
            if [ ! -f "${workdir}/.config" ]; then
                pkg=("${PKG_CONKY[@]}")
            fi
            ;;
    esac

    if [ -z $pkg ]; then
        echo "Everything is up-to-date!"
    fi

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
        printf "\n==> Removing %s...\n" "${elt}"
    done
}

lcars_restore()
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        printf "\n==> Attempting to restore %s...\n" "${elt}"
    done
}


### Install function ###
lcars_install() 
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        printf "\n==> Installing %s...\n" "${elt}"
        _install $elt
    done
}

lcars_activate()
{
    for elt in "${MY_ELEMENTS[@]}"
    do
        printf "\n==> Attempting to activate %s...\n" "${elt}"
        _activate $elt
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
                echo "==> Creating: ${work_dir}/${LCARS}"
                _smk_dir ${work_dir}/${LCARS}
                [ "$?" == 1 ] && exit 1
            fi
            # Copy config'd files to usr/share
            sudo cp ${LCARS_HOME}${MY_SOUNDS}/* ${work_dir}/${LCARS}/
            ;;

        icon)
            # Install LCARS multipurpose icon
            work_dir=${LCARS_SHARE}
            echo "Installing multipurpose icon..."
            echo "==> Copying to: ${work_dir}"
            sudo cp ${LCARS_HOME}${MY_ICONS}/${LCARS_ICON} ${work_dir}
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


#### ACTIVATE ELEMENT subroutine ####

_activate() {

    case "$1" in
        sound)
            if $(contains_elt "xfce" "$MY_XENV"); then
            # find xkb user config folder
                if [ ! -d "${HOME}/.xkb" ]; then
                    echo "Config directory ~/.xkb not found for xkbevd.cf."
                    _mk_dir ${HOME}/.xkb
                    [ "$?" == 1 ] && exit 1
                fi
            # if no xkbevd config then copy config file in, else abort
                if [ ! -f "${HOME}/.xkb/xkbevd.cf" ]; then
                    echo "Config file xkbevd.cf not found. Copying it to ~/.xkb now."
                    cp ./lib${LCARS_CONFD}/xkb/xkbevd.cf ${HOME}/.xkb/
                else
                    echo "Existing config file xkbevd.cf found. Aborting activation."
                    exit 1
                fi
            # one-time activation
                echo "Executing command 'sudo xkbevd -bg' in the shell."
                echo "To activate permanently add 'xkbevd -bg' to your ~/.xinitrc file."
                sudo xkbevd -bg
                printf "\nYou should hear an LCARS alert sound... NOW!\n \a"
            else
                echo "Bell activation only supported for Xfce with xkbevd."
                exit 1
            fi

            ;;

        conky)
            echo "Attempting activation of Conky!"
            source ${LCARS_SHARE}/conky_delay_start
            ;;
    esac

}
