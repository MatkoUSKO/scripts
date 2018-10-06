#!/bin/bash

print_commands() {
  echo lock
  echo logout
  echo suspend
  echo hibernate
  echo reboot
  echo shutdown
}

lock() {
  #i3lock;
  ~/scripts/lock_screen.sh
}

case "$1" in
  lock)
    lock
    ;;
  logout)
    i3-msg exit
    ;;
  suspend)
    lock && systemctl suspend
    ;;
  hibernate)
    lock && systemctl hibernate
    ;;
  reboot)
    systemctl reboot
    ;;
  shutdown)
    systemctl poweroff
    ;;
  *)
    print_commands
    ;;
esac

exit 0

