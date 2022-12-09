#!/bin/bash

filename=$1
n_tickets=$2
seed=$3

function sha3-512 {
  rawsha=$(echo $1 | openssl dgst -sha3-512 -r)
  read -ra sha <<< "$rawsha"
  tr '[:lower:]' '[:upper:]' <<< ${sha[0]}
}

function ticket {
  hash=$(sha3-512 "$1$seed")
  #hash="FF"
  n_tickets_hex=$(echo "ibase=10; obase=16; $n_tickets" | bc)
  echo "obase=10; ibase=16; ($hash % $n_tickets_hex) + 1" | bc
}

cat "$filename" | while read -r student
do
  echo "$(ticket "$student")"
done
