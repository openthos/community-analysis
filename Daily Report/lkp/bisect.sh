#! /bin/bash 

kernel=$1
rootfs=$2
commit=

DATE=`date +%Y%m%d%H`
IS_NEW=N
kernel_dir=/home/linux/lkp/kernel/linux
lkp_dir=/home/linux/lkp
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
		pushd $kernel_dir && git reset --hard $1 && make
		cp arch/x86_64/boot/bzImage $lkp_dir
		popd
	fi

}


unset good_commit_id
unset bad_commit_id
function git_bisect()
{
	set -x
	pushd $kernel_dir

	git bisect start && git bisect good $1
	commit=`git bisect bad $2  | tail -1 | awk -F "]" '{print $1}' | awk -F "[" '{print $2}'`
	echo commit $commit
	git bisect reset
	popd
	
	if [ -z "$commit"]; then
		echo "That is OK!"
		return
	fi

	test_commit_is_ok $commit
	ret=$?
	if [ $ret == 0 ]; then
		echo "ok"
		echo $commit > commit_ok_log.txt
		git_bisect $commit  $bad_commit_id
	else if [ $ret == 1 ]; then
		echo "no"
		good_commit_id=`cat commit_ok_log.txt`
		git_bisect $good_commit_id  $commit
		fi
	fi
	
	set +x
}

head=1
unset COMMITS
function get_kernel_commit()
{
	local n
	if [ -d $kernel_dir ]
	then
		pushd $kernel_dir
		commit_ok=`cat $lkp_dir/commit_ok_log.txt`
		n=`git log | grep "^commit" | grep -n "$commit_ok" | awk -F ":" '{print $1}'`
		commits=`git log | grep -n "^commit" | head -$n | awk '{print $2}'`
		for c in $commits
		do
			COMMITS=(${COMMITS[@]} $c)
		done 
		commit=`git log | grep "^commit" | head -1 |  awk '{print $2}'`
		head=$(($head+1))
		fi
	popd
}

function kill_qemu()
{
	sleep 20s
	pid=`ps -aux | grep "qemu" | head -1 | awk '{print $2}'`
	kill -9 $pid
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


function test_is_go_on()
{
	set -x
	#if [ test_kernel_update == -1111 ]; then
	if [ 1 == 1 ]; then
		get_kernel_commit
		echo commit  $commit
		test_commit_is_ok $commit
		if [ $? == 1 ]; then
			good_commit_id=`cat commit_ok_log.txt`
			git_bisect $good_commit_id  $bad_commit_id
		fi

	else
		echo "There is no update,nohing to do !!!!"
	fi
	set +x
}


if [ $# -eq  1 ]; then
	echo ${1##*=} > commit_ok_log.txt
	test_is_go_on
	echo good_commit_id $good_commit_id
	echo bad_commit_id $bad_commit_id
else
	echo "Plead input the commit that can be used!"
fi
