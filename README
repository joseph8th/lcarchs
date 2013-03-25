 __________________________________________________________ 
(                                                          )
(                                   /LCARchS /0.3/gx       )
(             _____________________________________________)
(            (
(____________)
 ~~~~~~~~~~~~   Another LCARS project. Designed to work
|     readme |  with LCARS-Desktop and LCARS-GTK themes.
|____________|  This version optimized on ArchLinux/Xfce4.
 ~~~~~~~~~~~~
|     author |  Joseph Edwards VIII <coriolisjoh@msn.com>
|            |  Somewhere in the world.
 ~~~~~~~~~~~~

USAGE:

  lcarchs -h

THIS VERSION:

  * VERSION LCARchS/gx: Optimized on ArchLinux with Xfce4, GTK2, XDM and retains GNOME2 and Metacity theme installers, though they are now ugly as hell. I use Adwaita with Compiz/Emerald for pretty.

  * NOTE: This is an almost as full-functioning-as-it-will-ever-be version of my theme element installer because the next version will be a whole other (better) beast. 


DEPENDENCIES:

Dependencies in turn depend on the DE/WM combination, given as a flag to the '-x' option at the command line.

  dbg: any
  sound: any
  gdm: [GNOME2/3 Desktop Manager]
  theme: [GTK-2.0]
    -x meta: [GNOME-2.x, compiz, Nautilus]
    -a -x xfce: [xfce4, xfwm4, xfce-query]
  conky: [conky]
    -a -x xfce [qiv]

INCLUDED FILES:

  * ./lcarchs - LCARchS command line UI.
  * ./lib/lcars.conf - Main config. Edit this to suit.
  * ./lib/functions.sh - Functions like install and remove $pkg.
  * ./lib/sounds/ - An LCARS beep.

  * ./lib/themes/
    - LCARS-GTK-1.2.tar.gz: 
      http://xfce-look.org/content/show.php/LCARS-Desktop+GTK+Theme?content=92578
    - LCARS-Desktop-1.2.tar.gz:
      http://gnome-look.org/content/show.php/LCARS-Desktop?content=91988

  * ./lib/hacks/conky/
    - .conkyrc: Conky config file optimized for default desktop background.
    - conky_delay_start: Conky startup script.

  * ./lib/backgrounds/
    - default_lcars_gx.jpg: 1280x800 optimized for 2-window conky display
    - TMPLcars.png: 1280x800 optimized for GDM login screen

NOTES:

Not ambitious (yet) this project aggregates and integrates the open-source efforts of other coders and designers, while revising these efforts to conform the LCARS standards offered by the LCARS Standards Development Board (http://www.lcarsdeveloper.com/). That said, this project supports the rare efforts to create an LCARS terminal emulator based on Linux (similar to LCARS32 or LCARS Terminal Emulator for Windows).

* Gnome theme depends on Compiz window decorator! I did everything using LMDE by installing Gnome/Compiz and logging in using GNOME Classic (2.0) session. Gnome 3 is someone else's problem.

* Conky installer installs configs only. You need to install conky and qiv if you have transparency problems with the desktop and conky. Here's what the conky_delay_start script does (ver. LCARS-gx), before starting conky:

  qiv --root /usr/share/backgrounds/lcars_gx/default_lcars_gx.jpg

This should solve the desktop refresh problem that prevents GNOME2 and Xfce4 users from clicking on their desktops while conky is running!


CHANGE LOG:

VERSION LCARchS:
  x/00 -  Optimized on ArchLinux with Xfce4 and GNOME3 GDM. Removal scripts added.
          Activation/restoration scripts added for some Xf(ce/wm) elements.
          lcarchs: No more 'install.sh' script. Now use lcarchs [options].
          lib/: lcarsrc.sh moved to lcars.conf and src/ changed to lib/
          Option functions (install, remove, etc.) moved to lib/functions.sh.
  0.3gx - Uninstallers mostly completed (still no rotation).
          Activation where it was easy. Otherwise activation is still manual.

VERSION LCARS-gx:
  0.0 -   My personal Mint 11 theme tweaking LCARS-GTK and LCARS-Desktop.
  0.1g -  Mere aggregation of installable files, folders, settings, and sources to be installed on a new LMDE installation (GNOME origs).
  0.1x -  install.sh: Install backdrop and tweaked LCARS-GTK ('bg' and 'gtk' options).
  0.2x -  install.sh: Hijack Mint login screen default_background.jpg symlink ('bg').
  0.3x -  install.sh: Install conkyrc's and conky_delay_start; activate conky ('conky' option).
  0.3 -   install.sh: Install LCARS-Desktop ('gnome' option, so now supports both).