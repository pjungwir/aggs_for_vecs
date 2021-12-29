#!/bin/bash
# set -eu

# Run a make target against all versions listed in .versions.

target="$1"

function usage() {
  echo "USAGE: multi.sh <target>"
  echo "  Runs a makefile target against all Postgres installations listed in .versions."
  echo "  <target> should be install or installcheck."
  exit 1
}

if [ -z "$target" ]; then
  usage
fi

if [ ! -e ".versions" ]; then
  echo "No .versions file found. See .versions.sample for details"
  exit 1
fi

while IFS= read -r line; do
  version=$(echo "$line" | cut -d, -f1)
  port=$(echo "$line" | cut -d, -f2)

  echo "================================"
  echo "============= ${version} ==============="
  echo "================================"

  # Make sure we use the appropriate pg_config:
  # TODO: Support some other way of finding the bin for each version.
  # On a Mac with homebrew we want something like /usr/local/Cellar/postgresql@9.3/9.3.25/bin.
  export PATH="/usr/lib/postgresql/${version}/bin:${PATH}"
  # pg_config

  case "$target" in
    install)
      make clean && make && sudo env PATH="${PATH}" make install
      ;;
    installcheck)
      rm -f "regression.${version}.diffs" "regression.${version}.out"
      PGPORT="${port}" make installcheck
      if [ -e regression.diffs ]; then
        cp regression.diffs "regression.${version}.diffs"
      fi
      if [ -e regression.out ]; then
        cp regression.out "regression.${version}.out"
      fi
      ;;
    *)
      usage
  esac
done < .versions
