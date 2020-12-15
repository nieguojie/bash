#!/bin/bash
fun1() {
    echo 1
}

fun2() {
    echo 2
}

fun3() {
    echo 3

}

proname=(fun1 fun2 fun3)
for num in ${proname[*]}
do
    read -p "deploy $num Y|y :" pro
    if [ $pro == "Y" -o $pro == "y" ];then
        $num
    fi
done
