#!/bin/bash

source .env

CASCADE_DOS_TYPENAME=$1
CASCADE_DOS_PRICE=$2

if [ -z "$CASCADE_ADMIN_CAP_ID" ]; then
    echo "CASCADE_ADMIN_CAP_ID env var is required."
    exit 1
fi

if [ -z "$CASCADE_MENU_ID" ]; then
    echo "CASCADE_MENU_ID env var is required."
    exit 1
fi

if [ -z "$CASCADE_PACKAGE_ID" ]; then
    echo "CASCADE_PACKAGE_ID env var is required."
    exit 1
fi

if [ -z "$CASCADE_DOS_TYPENAME" ]; then
    echo "Usage: $0 <CASCADE_DOS_TYPENAME> <CASCADE_DOS_PRICE>"
    exit 1
fi

if [ -z "$CASCADE_DOS_PRICE" ]; then
    echo "Usage: $0 <CASCADE_DOS_TYPENAME> <CASCADE_DOS_PRICE>"
    exit 1
fi

sui client ptb \
    --move-call $CASCADE_PACKAGE_ID::menu::add_price \
        "<$CASCADE_DOS_TYPENAME>" \
        "@$CASCADE_MENU_ID" \
        "@$CASCADE_ADMIN_CAP_ID" \
        $CASCADE_DOS_PRICE \
    --gas-budget 10000000