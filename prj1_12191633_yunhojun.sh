#!/bin/bash

Manual(){
	echo "---------------------------"
	echo "User Name: Yun Ho-jun"
	echo "Student Number: 12191633"
	echo "[ MENU ]"
	echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
	echo "2. Get the data of action genre movies from 'u.item'"
	echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
	echo "4. Delete the 'IMDb URL' from 'u.item'"
	echo "5. Get the data about user from 'u.user'"
	echo "6. Modify the format of 'release data' in 'u.item'"
	echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
	echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
	echo "9. Exit"
	echo "---------------------------"
}

func1(){
	echo
	local id
	read -p "Please enter 'movie id' (1~1682): " id
	echo
	cat u.item | awk -v a=$id -F\| '$1 == a {print}'
	echo
}

func2(){
	echo
	local yn
	read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n) : " yn
	if [ "$yn" = "y" ]
	then 
		echo
		cat u.item | awk -F\| '$7 == 1 {print $1, $2}' | awk 'NR<=10 {print}'
	fi
	echo
}

func3(){
	echo
	local mid
	read -p "Please enter the 'movie id' (1~1682) : " mid
	echo
	echo -n "arvege rating of $mid: "
	cat u.data | awk -v a=$mid '$2 == a {b+=$3; c+=1} END {print b/c}'
	echo
}

func4(){
	echo
	local yn
	read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n) : " yn
	if [ "$yn" = "y" ]
	then
		echo
		cat u.item | awk -F\| 'NR<=10 {print}' | sed 's/http[^|]*|/|/g'	
	fi
	echo 
}

func5(){
	echo
	local yn
	read -p "Do you want to get the data about users from 'u.user'? (y/n) : " yn
      	if [ "$yn" = "y" ]
	then
		echo
		cat u.user | awk -F\| 'NR<=10' | sed 's/M/male/' | sed 's/F/female/' | awk -F\| '{print "user " $1 " is " $2 " years old " $3 " " $4}'
	fi
	echo
}

func6(){
	echo
	cat u.item | awk -F \- 'BEGIN {
		split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", months, " ")
	}
	NR >= 1673{
		for(i = 1; i <= 12; i++){
			if(months[i] == $2) {
				$2 = sprintf("%02d", i)
				break
			}
		}
		print
	}' | sed -E 's/([0-9]{2}) ([0-9]{2}) ([0-9]{4})/\3\2\1/g'
	echo
}

func7(){
	echo
	local uid
	read -p "Please enter the 'user id'(1~943) : " uid
	echo
	out=$(cat u.data | awk -v a=$uid '$1 == a{print $2}' | sort -n)
	echo $out | sed 's/\s/|/g'
	echo
	arr=($out)
	for i in $(seq 0 9)
	do
		cat u.item | awk -v a="${arr[$i]}" -F \| '$1==a{print $1 "|" $2}'
	done
	echo
}

func8(){
	echo
	local yn
	read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) : " yn
	
	if [ "$yn" = "y" ]
	then
		uid=$(cat u.user | awk -F \| '$2>=20 && $2<30 && $4=="programmer"{printf "%s ", $1}')
		echo
		for i in $(seq 1 1682)
		do
			cat u.data | awk -v a="$uid" -v mid="$i" 'BEGIN{split(a, arr, " ")}
			$2 == mid {
			for(i in arr){
				if(arr[i] == $1){
					b+=$3
					c++
				}
			}
		} END {if(b!=0) print mid " " b/c}'
		done
	fi
	echo
}

func9(){
	echo "Bye!"
	exit
}

Manual
input=0
while :
do
	read -p "Enter your choice [ 1-9 ] " input
	case "$input" in
		"1") func1 ;;
		"2") func2 ;;
		"3") func3 ;;
		"4") func4 ;;
		"5") func5 ;;
		"6") func6 ;;
		"7") func7 ;;
		"8") func8 ;;
		"9") func9 ;;
	esac
done
