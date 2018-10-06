#toggle mute

help() {
  echo "sound control using pactl"
  echo "-h to print this beautiful help"
  echo "-s to override sink"
}

get_volume() {
  sink=$1
  volume_str=$(pactl list sinks | perl -lne 'print if /$sink/ .. /Volume:/' | grep "Volume:")
  left_vol=$(echo $volume_str | sed "s/^.*front-left: [0-9]\+ \/ \([0-9]\+\)%.*$/\1/g")
  right_vol=$(echo $volume_str | sed "s/^.*front-right: [0-9]\+ \/ \([0-9]\+\)%.*$/\1/g")
  volume=$((($left_vol+$right_vol)/2))
  echo $volume
}

raise_volume() {
  sink=$1
  step=$2
  pactl set-sink-volume $sink +$step%
  volume=$(get_volume $sink) 
  if [ "$volume" -gt "100" ]; then
    pactl set-sink-volume $sink 100%
  fi
}

lower_volume() {
  sink=$1
  step=$2
  pactl set-sink-volume $sink -$step%
}

toggle_mute() {
  sink=$1
  pactl set-sink-mute $sink toggle
}

# set sink to current default sink
sink=$(pactl info | grep "Default Sink:" | sed "s/Default Sink: \(.*\)/\1/g")
step=2
actions=""

while getopts ":s:k:hVrlm" opt; do
  case $opt in
    s)
      sink=$OPTARG
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
