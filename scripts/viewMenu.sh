#!/bin/bash

source .env

if [ -z "$CASCADE_MENU_ID" ]; then
    echo "CASCADE_MENU_ID is not set"
    exit 1
fi

MENU=$(sui client object $CASCADE_MENU_ID --json)
MENU_TABLE=$(echo $MENU | jq -r '.content.fields.prices.fields.id.id')
MENU_ITEMS=$(sui client dynamic-field $MENU_TABLE --json | jq '.data')

echo "$MENU_ITEMS" | jq -c '.[]' | while read -r item; do
    # Process each item here
    MENU_ITEM_ID=$(echo $item | jq -r '.objectId')
    MENU_ITEM=$(sui client object $MENU_ITEM_ID --json)
    echo "0x$(echo "$MENU_ITEM" | jq -r '.content.fields.name.fields.name') - $(echo "$MENU_ITEM" | jq -r '.content.fields.value') MIST"
done