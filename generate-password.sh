#!/bin/bash

read -sp "Enter password: " password
echo
bcrypt_hash=$(python3 bcrypt_hash.py "$password")
echo "Bcrypt hash: $bcrypt_hash"
