########################
# operation functions
########################
function confirmSubDomain() {
  if [ -z "$1" ]; then
    printf "Usage:\\n% confirmDocumentRoot /sim.dokoyorimo.com/laravel_application\\n"
    exit 1
  fi

  domain="$1.local"
  for f in $(getVhostDir)/web/conf.d/extra/*; do
   if grep -q $domain $f; then
      printf "既に${domain}が設定されております。\\n"
      printf "${f}\\n"
      return 1;
   fi
  done

  echo $domain
  return 0;
}

function confirmDocumentRoot() {
  if [ -z "$1" ]; then
    printf "Usage:\\n% confirmDocumentRoot /sim.dokoyorimo.com/laravel_application\\n"
    exit 1
  fi

  documentRoot="/var/www$1"
  for f in $(getVhostDir)/web/conf.d/extra/*; do
   if grep -q $documentRoot $f; then
      printf "既に${documentRoot}が設定されております。\\n"
      printf "${f}\\n"
      return 1;
   fi
  done

  echo $documentRoot
  return 0;
}

function getVhostDir() {
  mydir="$(cd "$(dirname "$BASH_SOURCE")" && pwd)" || {
      printf "Error getting script directory" >&2
      exit 1
  }
  echo ${mydir%/shells}
}


