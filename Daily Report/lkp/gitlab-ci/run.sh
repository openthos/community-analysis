#! /bin/bash 

kernel=$1
rootfs=$2
commit=

DATE=`date +%Y%m%d%H`
kernel_dir=`echo ${3##*=}`
function get_kernel_commit()
{
	echo $kernel_dir
	if [ -d $kernel_dir ]
	then
		pushd $kernel_dir
		commit=`git log | grep "^commit" | head -15 | tail -1 | cut -d " " -f 2`
		popd
	fi
}

unset MENU_CHOICES
function add_benchmark()
{
    local new_combo=$1
    local c
    for c in ${MENU_CHOICES[@]} ; do
        if [ "$new_combo" = "$c" ] ; then
            return
        fi
    done
    MENU_CHOICES=(${MENU_CHOICES[@]} $new_combo)
}


add_benchmark ebizzy
add_benchmark phoronix-test-suite 

function print_menu()
{
    echo "Lunch menu... pick a choice:"
	ARRAY=$1
    local i=1
    local choice
	echo ARRAY ${ARRAY[*]} ${#ARRAY[@]}
    for choice in ${ARRAY[*]}
    do
        echo "     $i. $choice"
        i=$(($i+1))
    done
}
unset selection
unset bootloader_append
bootloader_arg="root=/dev/sda rw rdinit=/sbin/init console=ttyS0"
function lunch_benchmark()
{
	local answer

	print_menu "${MENU_CHOICES[*]}"
	#echo -n "Which would you like? "
	#read answer


	if [ -z "$answer" ]
	then
		answer=1
		if [ $answer -le ${#MENU_CHOICES[@]} ]
		then
			n=`expr $answer - 1`
			selection=${MENU_CHOICES[$n]}
			bootloader_append=(${bootloader_append[$@]} "job$n=$selection")
			echo $bootloader_append
		fi
	else
		exit 0
	fi
	bootloader_arg="$bootloader_arg $bootloader_append"
	echo $bootloader_arg

}

host_shared="/home/gitlab-runner/lkp/result"
function run_kvm()
{
	[[ ! -d $host_shared ]] && mkdir -p $host_shared
	[[ -f $host_shared/boot ]] && rm $host_shared/boot
	[[ -f log.txt ]] && rm log.txt
	unset fs9p
	fs9p="-fsdev local,id=id_dev,path=${host_shared},security_model=none -device virtio-9p-pci,fsdev=id_dev,mount_tag=9p_mount"
	set -x
	if [ $# == 3 ]; then
		kill_qemu &
		qemu-system-x86_64  -nographic   -m 2G $fs9p -append "$bootloader_arg $3 \
			job_num=`expr ${#MENU_CHOICES[@]} - 1`"    -kernel $1  -hda $2 > log.txt 2>&1
		if [ $? == 0 ]; then
			return  0
		else
			return  1
		fi
	else
		kill_qemu &
		qemu-system-x86_64  -nographic  -m 2G $fs9p -append "$bootloader_arg \
			job_num=`expr ${#MENU_CHOICES[@]} - 1`"  -kernel $1  -hda $2  > log.txt 2>&1
		if [ $? == 0 ]; then
			return 0
		else
			return 1
		fi
	fi
	set +x
}

function kill_qemu()
{
	sleep 20s
	grep "Kernel panic"  log.txt 2> /dev/null
	if [ $? == 0 ]; then
		pid=`ps -aux | grep "qemu" | head -1 | awk '{print $2}'`
		if [ -n $pid ]; then
			kill -9 $pid
		fi
	fi
}


unset BENCHMAR_MENU
function add_analyze_benchmark()
{
    local new_benchmark=$1
    local c
    for c in ${BENCHMAR_MENU[@]} ; do
        if [ "$new_benchmark" = "$c" ] ; then
            return
        fi
    done
    BENCHMAR_MENU=(${BENCHMAR_MENU[@]} $new_benchmark)
}

unset selection
function lunch_analyze_benchmark()
{
    local answer

    print_menu "${BENCHMAR_MENU[*]}"
    #echo -n "Which would you like? "
    #read answer

	if [ -z "$answer" ]
	then
		answer=1
		if [ $answer -le ${#BENCHMAR_MENU[@]} ]
		then
			n=`expr $answer - 1`
			selection=${BENCHMAR_MENU[$n]}
			echo ====== $n $selection
		fi
	else
		exit 0
	fi
}

function set_analyze_benchmark(){
	benchmark=$1
	for f in `ls result`
	do
		job=`echo -n $f | cut -d "_" -f 1`
		echo "job  $job"
		if [ "$benchmark" == "$job" ]; then
			j=`echo -n $f | cut -d "_" -f 2`
			add_analyze_benchmark $j
		fi
	done
}
unset result
unset  RESULT
unset filedate
function get_result(){
	local n=0
	local sum=0

	pushd $host_shared
	if [ -f compare ]; then
		rm compare 
	fi

	for f in `ls`
	do
		job=`echo -n $f | awk -F '_' '{print $2}'`
		if [ "$selection" == "$job" ]; then
			file_date=`echo -n $f | awk -F '_' '{print $3}'`
			FILE_LIST=(${FILE_LIST[@]} $file_date)
		fi
	done

	for f in `ls`
	do
		job=`echo -n $f | awk -F '_' '{print $2}'`
		str=`echo -n $selection | awk -F '-' '{print $1}'`
		nn=`cat  $f | grep -n $str | awk -F ':' '{print $1}'`
		nn=`expr $nn + 4`
		commit_id=`head -$nn  $f | tail -1 | awk '{print $1}'`
		echo -----  $nn $commit_id $commit
		if [[ "$selection" == "$job" ]] && [[ "$commit_id" == "$commit" ]]; then
			echo $commit_id
			filedate=${FILE_LIST[0]}
			local i=0
			for ff  in ${FILE_LIST[@]}
			do
				if [ $filedate -lt ${FILE_LIST[i]} ]; then
					filedate=${FILE_LIST[i]}    #保留最新日期
				fi
				i=$(($i+1))
			done
		fi
	done
	if [ -s ${benchmark}_${selection}_${filedate}_compare ]; then
		m=`cat  ${benchmark}_${selection}_${filedate}_compare  | \
			grep -n "%stddev" | awk -F ':' '{print $1}'`
		t=`wc -l ${benchmark}_${selection}_${filedate}_compare | awk  '{print $1}'`
		echo "m " $m " t " $t
		t=`expr $t - 1`
		r=`expr $t - $m - 1`     #有效数据项行数
		cat ${benchmark}_${selection}_${filedate}_compare | head -$t | tail -$r | while read line
		do
			echo $line >> compare
		done
	else
		echo "file not found or file is null!"
		exit 1 
	fi

	while read line
	do
		echo line  $line
		l=`echo $line | awk '{print NF}'`
		if [ $l -eq 8 ]; then
			rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
		elif [ $l -eq 7 ]; then
			s=`echo $line | awk '{print $6}'`
			if [[ $s == *±* ]]; then 
				rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
			else
				rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`
			fi
		elif [ $l -eq 6 ]; then
			s=`echo $line | awk '{print $5}'`
			if [[ $s == *±* ]]; then 
				rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`
			else
				s=`echo $line | awk '{print $4}'`
				if [[ $s == *±* ]]; then
					rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
				else
					rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
				fi
			fi
		elif [ $l -eq 5 ]; then
			s=`echo $line | awk '{print $2}'`
			if [[ $s == *±* ]]; then 
				rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`
			else
				rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
			fi
		elif [ $l -le 4 ]; then
			rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
		fi

		if [[ $rs == *+* ]]; then
			rs=`echo $rs | awk -F "+" '{print $2}'`
		fi
		echo rs  $rs
		RESULT=(${RESULT[@]} $rs)
		
	    done < compare
	popd

	local sum=0
	for i in ${RESULT[@]}
	do
		echo iiiiii $i
		sum=$(echo "scale=1; $sum  + $i" | bc)
	done
	ave=$(echo "scale=1; $sum  / ${#RESULT[@]}" | bc)
	var=`echo $ave | awk -F "." '{print $1}'`	
	if [[ $var  == " " ]] || [[ $var == "" ]]; then
		echo "The calculated average is "0${ave}% > result.txt
	elif  [[ $var  == "-" ]]; then
		echo "The calculated average is -0."`echo ${ave} \
			| awk -F "." '{print $2}'`% > result.txt
	else
		echo "The calculated average is "${ave}% > result.txt
	fi

}
MAIL_LIST=miaodexing@openthos.org   #,yuchen@mail.tsinghua.edu.cn
function mail_result()
{
	tile=`cat result.txt`
	s-nail -s "The  result of lkp-test  $benchmark from gitlab-ci  --- $tile"  $MAIL_LIST <  result/${benchmark}_${selection}_${filedate}_compare
}

get_kernel_commit
lunch_benchmark
echo commit  $commit
run_kvm $kernel $rootfs
[[ $? == 1 ]] && echo $commit > result/commit_no_ok && exit 1 
run_kvm $kernel $rootfs "commit=${commit}"
[[ $? == 1 ]] && echo $commit > result/commit_no_ok && exit 1 

set_analyze_benchmark $selection
lunch_analyze_benchmark
get_result
mail_result
set -x
if [ -f $host_shared/boot ]; then
	grep "boot successfully" $host_shared/boot
	if [ $? == 0 ]; then
		echo "successfully "
		echo $commit > result/commit_ok
	else 
		echo "error!!!! commit : $commit"
		echo $commit > result/commit_no_ok
	fi
	rm $host_shared/boot 2> /dev/null
fi
set +x
echo "end------------------"
