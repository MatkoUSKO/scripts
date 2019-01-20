#toggle mute

help() {
  echo "sound control using pactl"
  echo "-h to print this beautiful help"
  echo "-s to override sink"
}

get_all_sinks() {
  list_outputs=$(pactl list sinks | grep "Name: " | cut -d$'\t' -f 2- | cut -d' ' -f 2-)

  for i in $list_outputs; do
    echo $i
  done
}

get_volume() {
  sink=$1

  volume_str=$(pactl list sinks | perl -lne "print if /$sink/ .. /Volume:/" | grep "Volume:" | sed -n 1p)

  left_vol=$(echo $volume_str | sed "s/^.*front-left: [0-9]\+ \/ \([0-9]\+\)%.*$/\1/g")
  right_vol=$(echo $volume_str | sed "s/^.*front-right: [0-9]\+ \/ \([0-9]\+\)%.*$/\1/g")

  volume=$((($left_vol+$right_vol)/2))
  echo $volume
}

raise_volume() {
  sink=$1
  step=$2

  if [ $sink == "all" ]; then
    for i in $(get_all_sinks); do
      pactl set-sink-volume $i +$step%
      volume=$(get_volume $i) 
      if [ "$volume" -gt "100" ]; then
        pactl set-sink-volume $i 100%
      fi
    done
  else
    pactl set-sink-volume $sink +$step%
    volume=$(get_volume $sink) 
    if [ "$volume" -gt "100" ]; then
      pactl set-sink-volume $sink 100%
    fi
    volume=$(get_volume $sink) 
  fi;
}

lower_volume() {
  sink=$1
  step=$2

  if [ $sink == "all" ]; then
    for i in $(get_all_sinks); do
      pactl set-sink-volume $i -$step%
    done
  else
    pactl set-sink-volume $sink -$step%
  fi;
}

toggle_mute() {
  sink=$1

  if [ $sink == "all" ]; then
    for i in $(get_all_sinks); do
      pactl set-sink-mute $i toggle
    done
  else
    pactl set-sink-mute $sink toggle
  fi;

}

# set sink to current default sink
sink=$(pactl info | grep "Default Sink:" | sed "s/Default Sink: \(.*\)/\1/g")
step=2
actions=""

while getopts ":s:k:hVrlm" opt; do
  case $opt in
    s)
      if [[ $OPTARG =~ [0-9]+ ]]; then
        readarray -t sinks <<< "$(get_all_sinks)"
        sink=${sinks[$OPTARG]}
      else
        sink=$OPTARG
      fi
      ;;
    k)
      step=$OPTARG
      ;;
    h)
      help
      exit 0
      ;;
    *)
      actions="${actions}$opt"
      ;;
    ?)
      echo "unknown flag: $OPTARG"
    esac
done

for i in $(seq 0 $((${#actions}-1))); do
  action=${actions:i:1}
  case $action in
    V)
      volume=$(get_volume $sink)
      echo "volume on sink $sink: $volume"
      ;;
    l)
      lower_volume $sink $step
      ;;
    r)
      raise_volume $sink $step
      ;;
    m)
      toggle_mute $sink
      ;;
  esac
done
