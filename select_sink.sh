#!/bin/bash

function get_selection {
  selection=$(echo "$*" | rofi -modi -dmenu -location 1 -matching regex -scroll-method 1)
  echo "$selection"
}

function select_output_sink {
  list_outputs=$(pactl list sinks | grep "Name: " | cut -d$'\t' -f 2- | cut -d' ' -f 2-)
  IFS=$'\n'
  list_inputs=($list_inputs)
  get_selection $list_outputs
}

function set_default_sink {
  selected_output=$(select_output_sink)
  pactl set-default-sink $selected_output
}

function move_sink {
  
  list_inputs=$(pactl list sink-inputs | grep -E "Sink Input" | sed "s/\t//g" | sed "s/Sink Input #\([0-9]*\)/\1/g")
  app_names=$(pactl list sink-inputs | grep -E "application\.name" | sed "s/\t//g" | \
    sed "s/application\.name = \"\(.*\)\"/\1/g")
  
  IFS=$'\n'
  list_inputs=($list_inputs)
  extended_app_names=("All (set default)" "All" $app_names)
  app_names=($app_names)
  selected_sink=
  
  selection=$(get_selection ${extended_app_names[@]})
  selected_output=$(select_output_sink)

  if [[ "$selection" = "All" ]]; then
    for i in ${list_inputs[@]}; do
      pactl move-sink-input "$i" "$selected_output"
    done
  elif [[ "$selection" = "All (set default)" ]]; then
    for i in ${list_inputs[@]}; do
      pactl move-sink-input "$i" "$selected_output"
    done
    pactl set-default-sink "$selected_output"
  else
    for(( i=0; i<${#list_inputs[@]}; i++ )); do
      if [[ "$selection" = "${app_names[i]}" ]]; then
          selected_sink=${list_inputs[i]}
      fi
    done
    pactl move-sink-input $selected_sink $selected_output
  fi

  
}

function print_help {
  echo "-h - print this help"
  echo "-s - set default sink"
  echo "-m - move sink input"
}

while getopts ":hsm" opt; do
  case $opt in
    h)
      print_help
      ;;
    s)
      set_default_sink
      ;;
    m)
      move_sink
      ;;
    *)
      print_help
      ;;
  esac
done

