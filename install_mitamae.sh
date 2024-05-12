source .versions.sh

case "$(uname)" in
  "Darwin")
    case "$(uname -m)" in
      "arm64")
        mitamae_file="mitamae-aarch64-darwin"
        ;;
      "x86_64")
        mitamae_file="mitamae-x86_64-darwin"
        ;;
    esac
    ;;
  "Linux")
    mitamae_file="mitamae-x86_64-linux"
    ;;
  *)
    echo "unknown uname: $(uname)"
    exit 1
    ;;
esac

if [ ! -e bin/mitamae-${MITAMAE_VERSION} ]; then
  curl -L -O "https://github.com/itamae-kitchen/mitamae/releases/download/v${MITAMAE_VERSION}/${mitamae_file}"
  chmod +x ${mitamae_file}
  mv ${mitamae_file} ./bin/mitamae-${MITAMAE_VERSION}
else
  echo "Already exists this version of miatamae"
fi
