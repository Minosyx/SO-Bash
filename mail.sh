#!/bin/bash
Recipient=$1
Subject="Greeting"
Message="Welcome to our site"
`mail -s $Subject $Recipient <<< $Message`
echo "mail -s $Subject $Recipient <<< \"$Message\""
