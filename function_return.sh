#!/bin/bash

function greeting() {

str="Hello, $name"
echo $str

}

name=$1
echo "name=$name"
val=$(greeting)
echo "Return value of the function is $val"
