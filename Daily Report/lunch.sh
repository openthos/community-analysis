#! /bin/bash 

kernel=$1
rootfs=$2
commit=

DATE=`date +%Y%m%d%H`
IS_NEW=N
kernel_dir=/home/linux/lkp/kernel/linux
BASE_DIR=$(cd $(dirname $0); pwd)

function test_kernel_update()
{
	pushd $kernel_dir > /dev/null
	repo sync > /dev/null
	wait
	repo manifest -r -o proc/$DATE.xml
	CMP_XML=`ls -t proc | awk 'NR==2'`
	diff proc/$DATE.xml proc/$CMP_XML
	RESULT_IS_DIFF=$?
	if [ $RESULT_IS_DIFF -eq 1 ]; then
		IS_NEW=Y
	elif [ -z $CMP_XML ]; then
		IS_NEW=Y
	elif [ $RESULT_IS_DIFF -eq 0 ]; then
		rm proc/$DATE.xml
	fi

	if [ $IS_NEW == N ]; then
		echo "There is no update"
		exit 1
	else 
		exit -1
	fi
}

function build_kernel()
{
	if [ -d $kernel_dir ]
	then
		cd $kernel_dir && make
	fi

}

function get_kernel_commit()
{
	if [ -d $kernel_dir ]
	then
		cd $kernel_dir && commit=`git log | grep "^commit" | head -2 | tail -1 | cut -d " " -f 2` && cd -
	fi
}

function backtrack()
{
	cd $kernel_dir && git reset --hard $1 && git reset --hard HEAD^
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

    echo
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

host_shared="/home/linux/lkp/result"
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
unset SUM
function get_result(){
	local n=0
	local sum=0

	for f in `ls result`
	do
		file_date=`echo -n $f | awk -F '_' '{print $3}'`
		FILE_LIST=(${FILE_LIST[@]} $file_date)
	done

	for f in `ls result`
	do
		job=`echo -n $f | awk -F '_' '{print $2}'`
		nn=`cat  result/$f | grep -n "^commit" | awk -F ':' '{print $1}'`
		nn=`expr $nn + 2`
		commit_id=`head -$nn  result/$f | tail -1 | awk '{print $1}'`
		echo $nn $commit_id
		if [ "$selection" == "$job" -a "$commit_id" == "$commit" ]; then
			local filedate=${FILE_LIST[0]}
			local i=0
			for ff  in ${FILE_LIST[@]}
			do
				if [ $filedate -lt ${FILE_LIST[i]} ]; then
					filedate=${FILE_LIST[i]}    #保留最新日期
				fi
				i=$(($i+1))
			done
			m=`cat  result/${benchmark}_${selection}_${filedate}_compare  | grep -n "%stddev" | awk -F ':' '{print $1}'`
			t=`wc -l result/${benchmark}_${selection}_${filedate}_compare | awk  '{print $1}'`
			t=`expr $t - 1`
			r=`expr $t - $m - 1`     #有效数据项行数
			cat result/${benchmark}_${selection}_${filedate}_compare | head -$t | tail -$r | while read line
			do
				echo $line > result/compare
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
		fi
	done

	local sum=0
	for i in ${RESULT[@]}
	do
		sum=$(echo "scale=1; $sum  + $i" | bc)
	done
	ave=$(echo "scale=1; $sum  / ${#RESULT[@]}" | bc)
	echo "The calculated average is "${ave}%
}


#if [ test_kernel_update == -1111 ]; then
if [ 1 == 1 ]; then
	get_kernel_commit
	lunch_benchmark
	echo commit  $commit
	#run_kvm bzImage_5.3 rootfs_ok.ext4 commit=fd8f64df95204951c3edd4c4a7817c909d55a100
	#run_kvm $kernel $rootfs
	run_kvm $kernel $rootfs "commit=${commit}"

	if [ -f $host_shared/boot ]; then
		grep "boot successfully" $host_shared/boot
		if [ $? == 0 ];then
			echo "successfully "
		else 
			echo "error!!!! commit : $commit"
		fi
		rm $host_shared/boot 2> /dev/null
	fi
else
	echo "There is no update,nohing to do !!!!"
fi
#backtrack $commit
set_analyze_benchmark $selection
lunch_analyze_benchmark
#res=`echo $(get_result) | awk '{print NF}'`
get_result
#echo $res
echo "end------------------"
