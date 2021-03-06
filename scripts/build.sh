#!/bin/bash
set -e

IS_COMPILE=false
IS_RESET_PROFILE=false
IS_DEPLOY=false

for var in "$@"
do
  case $var in
    -h|--help)
     echo "v1.0.0 - Jan 2022"
     echo "Utility script to help you compile, reset profile and deploy contracts on the NEAR blockchain"
     echo "Available options:"
     echo "| "
     echo "| --help | -h: Show this help message."
     echo "| "
     echo "| --compile | -c: Compiles for release with: RUSTFLAGS='-C link-arg=-s' cargo build --target wasm32-unknown-unknown --release"
     echo "| "
     echo "| --reset | -r: Resets the dev account id by deleting the .neardev folder, deploy to generate a new profile/account or create using the near-cli."
     echo "| "
     echo "| --deploy | -d: Deploys the contract on the NEAR testnet with: near dev-deploy --wasmFile ./out/main.wasm"
     echo "| "
     echo "| --all | -a: Does all the things! Compiles, resets and deploys"
     echo "| "
     echo " "
     echo "For more information please check the docs: https://docs.near.org/docs/develop/basics/getting-started"
     echo " "
     echo "Author:"
     echo "| Joaquim Ley <joaquimley@gmail.com> @joaquimley"
     echo "| Based on 'NEAR examples' build script available on GitHub: https://github.com/near-examples/NFT/blob/master/build.sh"
     echo " "
     echo "Issue tracker: https://github.com/JoaquimLey/near-utils/issues"
     ;;
     
    -d|--deploy)
      IS_DEPLOY=true
      ;;
    -r|--reset) 
      IS_RESET_PROFILE=true
      ;;
    -c|--compile)
      IS_COMPILE=true
      ;;
    -a|--all)
      IS_DEPLOY=true
      IS_RESET_PROFILE=true
      IS_COMPILE=true
      ;;
  esac
done

if $IS_COMPILE ; then
    echo "Compiling for release... 🤖"
    RUSTFLAGS='-C link-arg=-s' cargo build --target wasm32-unknown-unknown --release
    mkdir -p ./out
    cp target/wasm32-unknown-unknown/release/*.wasm ./out/main.wasm
    echo "---------------------------------------------------------"
    echo "Compile success! ⭐ Artifact exported to: ./out/main.wasm"
fi

if $IS_RESET_PROFILE; then
    echo "Reseting the neardev profile"
    rm -rf ./neardev
    echo "---------------------------------------------------------"
    echo ".neardev folder deleted 🗑, compile to generate a new dev-account"
fi

if $IS_DEPLOY; then
    echo "Deploying contract... ⛓️"
    near dev-deploy --wasmFile ./out/main.wasm
    echo "---------------------------------------------------------"
    echo "Contract deployed with success ✅" 

    echo "---------------------------------------------------------"
    echo "Load the new contract account id with:"
    echo "> source ./neardev/dev-account.env"
fi