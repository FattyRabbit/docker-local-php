########################
# operation functions
########################
function service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | cut -f1 -d' ') == $n.service ]]; then
        return 1
    else
        return 0
    fi
}

function convert_template() {
  if [ ! -f $1 ]; then
    echo "Usage:\n$ convertTemplate template.tpl > target.txt"
    exit 1
  fi

  while read line || [ -n "${line}" ]
  do
    echo $(eval echo "''${line}")
  done < $1
}

function installed_rpm() {
  if rpm -qa | grep $1-$2  2>&1 > /dev/null; then
    return 1
  else
    return 0
  fi
}