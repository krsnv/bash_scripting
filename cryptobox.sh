#!/bin/bash

# CRYPTOBOX
# @author Vladimir Krasnov <v@krsnv.ru>

# Fast and easy directory tar-gz compress and encryption/decryption.
# Uses OpenSSL.

# Copyright (c) 2016 Vladimir Krasnov

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Encrypt selected project (dir with contents)
function encrypt()
{
    if [[ ! -n "$1" ]]; then
        echo "Select dir to encrypt."
        exit 1
    fi

    if [[ ! -n "$2" ]]; then
        echo "Set a password to encrypt dir."
        exit 1
    fi

    DIR=$1
    PASSWORD=$2

    tar cvzf ${DIR}.tar.gz ${DIR} && \
    openssl enc -aes-256-cbc -e -k ${PASSWORD} -in ${DIR}.tar.gz -out ${DIR}.tar.gz.enc && \
    rm ${DIR}.tar.gz
}


# Encrypt selected project (create decrypted tar.gz)
function decrypt()
{
    if [[ ! -n "$1" ]]; then
        echo "Select .enc to decrypt."
        exit 1
    fi

    FILE=$1
    openssl enc -aes-256-cbc -d -in ${FILE}.tar.gz.enc -out ${FILE}.tar.gz
}


# Mass directories encryption in current directory
function encrypt_all()
{
    FILES=$(ls -F | grep / | sed "s|\/||")
    PASSWORD=$1

    if [[ ! -d "encrypted" ]]; then
        mkdir encrypted
    else
        echo "Directory with encrypted files seems to be already created."
        echo "Check this dir before new encryption."
        exit 1
    fi

    for ITEM in $FILES
    do
        encrypt ${ITEM} ${PASSWORD} && \
        mv ${ITEM}.tar.gz.enc ./encrypted/
    done
}


# Default action if no params entered
function show_help()
{
    echo "Use <encrypt> <dir> <password> for encrypting."
    echo "Use <decrypt> <dir> <password> for decrypting."
    echo "Use <encrypt_dirs> <password> for mass dirs encryption."
}


# CRYPTOBOX COMMANDS

if [[ ! -f $(which openssl) ]]; then
    echo "Install OpenSSL package before using this toolsbox."
    exit 1
fi

if [[ ! -n "$1" ]]; then
    show_help
    exit
fi

if [[ $1 == 'encrypt' ]]; then
    encrypt $2 $3
    exit
fi

if [[ $1 == 'decrypt' ]]; then
    decrypt $2
    exit
fi

if [[ $1 == 'encrypt_all' ]]; then
    encrypt_all $2
    exit
fi
