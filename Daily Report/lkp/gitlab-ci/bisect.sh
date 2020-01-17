#! /bin/bash 

kernel=$1
rootfs=$2
commit=

DATE=`date +%Y%m%d%H`
IS_NEW=N
kernel_dir=/home/linux/lkp/kernel/linux
kernel_dir=`echo ${2##*=}`
BASE_DIR=$(cd $(dirname $0); pwd)
lkp_dir=$BASE_DIR

function get_kernel_update()
{
	pushd $kernel_dir
	echo `git log | head -1 | awk '{print $2}'` > update.txt
	popd
}

function build_kernel()
{
	if [ -d $kernel_dir ]
	then
		pushd $kernel_dir && git reset --hard $1 && make x86_64_defconfig && make -j16
		cp arch/x86_64/boot/bzImage $lkp_dir
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
	echo -n "Which would you like? "
	read answer


	if [ -z "$answer" ]
	then
		exit 0
	elif (echo -n $answer | grep -q -e "^[0-9][0-9]*$")
	then
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

host_shared="${BASE_DIR}/result"
function run_kvm()
{
	[[ ! -d $host_shared ]] && mkdir -p $host_shared
	unset fs9p
	fs9p="-fsdev local,id=id_dev,path=${host_shared},security_model=none -device virtio-9p-pci,fsdev=id_dev,mount_tag=9p_mount"
	if [ $# == 3 ]; then
		qemu-system-x86_64  -nographic   -m 2G $fs9p -append "$bootloader_arg $3 \
		job_num=`expr ${#MENU_CHOICES[@]} - 1`"    -kernel $1  -hda $2
		#job_num=`expr ${#MENU_CHOICES[@]} - 1`"    -kernel $1  -hda $2 > log 2>&1
	else
		qemu-system-x86_64  -nographic  -m 2G $fs9p -append "$bootloader_arg \
		job_num=`expr ${#MENU_CHOICES[@]} - 1`"  -kernel $1  -hda $2
		#job_num=`expr ${#MENU_CHOICES[@]} - 1`"  -kernel $1  -hda $2 > log 2>&1
    fi
}

unset BENCHMAR_MENU
pushd $BASE_DIR > /dev/null

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
    echo -n "Which would you like? "
    read answer

    if [ -z "$answer" ]
    then
        exit 0
    elif (echo -n $answer | grep -q -e "^[0-9][0-9]*$")
    then
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
		#echo "job  $job"
		if [ "$benchmark" == "$job" ]; then
			j=`echo -n $f | cut -d "_" -f 2`
			add_analyze_benchmark $j
		fi
	done
}
unset result
unset  RESULT
function get_result(){
	local n=0
	local sum=0

	if [ -f result/compare ]; then
		rm result/compare 
	fi

	for f in `ls result`
	do
		job=`echo -n $f | awk -F '_' '{print $2}'`
		if [ "$selection" == "$job" ]; then
			file_date=`echo -n $f | awk -F '_' '{print $3}'`
			FILE_LIST=(${FILE_LIST[@]} $file_date)
		fi
	done

	for f in `ls result`
	do
		job=`echo -n $f | awk -F '_' '{print $2}'`
		str=`echo -n $selection | awk -F '-' '{print $1}'`
		nn=`cat  result/$f | grep -n $str | awk -F ':' '{print $1}'`
		nn=`expr $nn + 4`
		commit_id=`head -$nn  result/$f | tail -1 | awk '{print $1}'`
		if [ "$selection" == "$job" -a "$commit_id" == "$commit" ]; then
			echo $commit_id
			local filedate=${FILE_LIST[0]}
			local i=0
			for ff  in ${FILE_LIST[@]}
			do
				if [ $filedate -lt ${FILE_LIST[i]} ]; then
					filedate=${FILE_LIST[i]}    #保留最新日期
				fi
				i=$(($i+1))
			done
			if [ -f result/${benchmark}_${selection}_${filedate}_compare ]; then
				m=`cat  result/${benchmark}_${selection}_${filedate}_compare  | grep -n "%stddev" | awk -F ':' '{print $1}'`
				t=`wc -l result/${benchmark}_${selection}_${filedate}_compare | awk  '{print $1}'`
				t=`expr $t - 1`
				r=`expr $t - $m - 1`     #有效数据项行数
				cat result/${benchmark}_${selection}_${filedate}_compare | head -$t | tail -$r | while read line
				do
					echo $line >> result/compare
				done
				while read line
				do
					l=`echo $line | awk '{print NF}'`
					if [ $l -ge 6 ]; then
						rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
					else
						rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
					fi
					if [[ $rs == *+* ]]; then
						rs=`echo $rs | awk -F '+' '{print $2}'`
					fi
					RESULT=(${RESULT[@]} $rs)

					if [ "${line##* }" == "time.involuntary_context_switches" ]; then
						num=`echo $line | awk '{print NF}'`
						if [ $num -ge 6 ]; then
							result=`echo $line | awk '{print $4}'`
						else
							result=`echo $line | awk '{print $2}'`
						fi
						echo "time.involuntary_context_switches  result is "$result 
					fi
				done < result/compare
			else
				echo "file not found!"
				return 
			fi
	fi

	done

	local sum=0
	for i in ${RESULT[@]}
	do
		sum=$(echo "scale=1; $sum  + $i" | bc)
	done
	ave=$(echo "scale=1; $sum  / ${#RESULT[@]}" | bc)
	echo "##################################"
	echo "The calculated average is "${ave}%
}

unset good_commit_id
unset bad_commit_id
function git_bisect()
{
	set -x
	pushd $kernel_dir > /dev/null

	git bisect start && git bisect good $1
	commit=`git bisect bad $2  | tail -1 | awk -F "]" '{print $1}' | awk -F "[" '{print $2}'`
	echo commit $commit
	git bisect reset
	popd > /dev/null
	
	if [ -z "$commit" ]; then
		echo "That is OK!"
		return
	fi

	test_commit_is_ok $commit
	if [ $? == 0 ]; then
		echo "ok"
		echo $commit > commit_ok_log.txt
		git_bisect $commit  $bad_commit_id
	else
		echo "no"
		good_commit_id=`cat commit_ok_log.txt`
		git_bisect $good_commit_id  $commit
	fi
	
	set +x
}

head=1
unset COMMITS
function get_kernel_commit()
{
	commit_ok=`cat commit_ok_log.txt`
	local n
	if [ -d $kernel_dir ]
	then
		pushd $kernel_dir > /dev/null
		n=`git log | grep "^commit" | grep -n "$commit_ok" | awk -F ":" '{print $1}'`
		commits=`git log | grep -n "^commit" | head -$n | awk '{print $2}'`
		for c in $commits
		do
			COMMITS=(${COMMITS[@]} $c)
		done 
		commit=`git log | grep "^commit" | head -1 |  awk '{print $2}'`
		head=$(($head+1))
		fi
	popd > /dev/null
}

function kill_qemu()
{
	sleep 20s
	pid=`ps -aux | grep "qemu" | head -1 | awk '{print $2}'`
	if [ -n $pid ]; then
		kill -9 $pid
	fi
}
function test_commit_is_ok()
{
	set -x
	if [ -f kernel_ok_log.txt ]; then
		rm kernel_ok_log.txt
	fi
	if [ $# == 1 ]; then	
		echo ${COMMITS[2]}
		build_kernel $1
		wait
		kill_qemu &
		run_kvm  bzImage  rootfs_ok.ext4 "commit=$1" > kernel_ok_log.txt 2>&1  
		

		grep "Kernel panic"  kernel_ok_log.txt 2> /dev/null 
		if [ $? == 0 ]; then
			bad_commit_id=$1
			return 1
		else
			good_commit_id=$1
			echo $good_commit_id > commit_ok_log.txt
			return 0
		fi
	fi
}
function ff(){
	if [ 0 == 1 ];then
		grep "boot successfully" $host_shared/boot 2> /dev/null
		if [ $? == 0 ];then
			echo "successfully "
			good_commit_id=$1
			echo $good_commit_id > commit_ok_log.txt
			rm $host_shared/boot 2> /dev/null
			return  0
		else 
			echo "error!!!! commit : $1"
			bad_commit_id=$1
			rm $host_shared/boot 2> /dev/null
			return  1
		fi
	else
		echo "please input commit!"
		return 2
	fi
	set +x
}




function test_is_go_on()
{
	set -x
	#if [ test_kernel_update == -1111 ]; then
	get_kernel_commit
	echo commit  $commit
	test_commit_is_ok $commit
	if [ $? == 1 ]; then
		good_commit_id=`cat commit_ok_log.txt`
		git_bisect $good_commit_id  $bad_commit_id
	fi
	set +x
}

set -x
echo `pwd`  $BASE_DIR
if [ $# -eq  2 ]; then
	echo ${1##*=} > commit_ok_log.txt
	test_is_go_on
	echo good_commit_id $good_commit_id
	echo bad_commit_id $bad_commit_id
else
	echo "Plead input the commit that can be used!"
fi

set +x
