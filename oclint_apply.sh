#!/bin/bash

# 指定编码
export LANG="zh_CN.UTF-8"
export LC_COLLATE="zh_CN.UTF-8"
export LC_CTYPE="zh_CN.UTF-8"
export LC_MESSAGES="zh_CN.UTF-8"
export LC_MONETARY="zh_CN.UTF-8"
export LC_NUMERIC="zh_CN.UTF-8"
export LC_TIME="zh_CN.UTF-8"
export LC_ALL=

function checkDepend () {
	command -v xcpretty >/dev/null 2>&1 || { 
		echo >&2 "I require xcpretty but it's not installed.  Install：gem install xcpretty"; 
		exit
		}
	command -v oclint-json-compilation-database >/dev/null 2>&1 || { 
		echo >&2 "I require oclint-json-compilation-database but it's not installed.  Install：brew install oclint"; 
		exit
		}
}

function oclintForProject () {

	# 检测依赖
	checkDepend

	projectName=$1
	scheme=$2
    reportType=$3

    REPORT_PMD="pmd"
    REPORT_XCODE="xcode"
	
	myworkspace=${projectName}
	myscheme=${scheme} 
	echo "myworkspace是：${myworkspace}"
	echo "myscheme是：${myscheme}"
	echo "reportType为：${reportType}"

	# 清除上次编译数据
	if [ -d ./build/derivedData ]; then
		echo '-----清除上次编译数据derivedData-----'
		rm -rf ./build/derivedData
	fi

	# xcodebuild -workspace $myworkspace -scheme $myscheme clean
	xcodebuild clean

	echo '-----开始编译-----'

	# 生成编译数据
	xcodebuild -workspace ${myworkspace} -scheme ${myscheme} -sdk iphonesimulator -derivedDataPath ./build/derivedData -configuration Debug COMPILER_INDEX_STORE_ENABLE=NO | xcpretty -r json-compilation-database -o compile_commands.json
	

	if [ -f ./compile_commands.json ]
		then
		echo '-----编译数据生成完毕-----'
	else
		echo "-----生成编译数据失败-----"
		return -1
	fi

	echo '-----分析中-----'

	# 自定义排除警告的目录，将目录字符串加到数组里面
	# 转化为：-e Debug.m -e Port.m -e Test
	exclude_files=("cardloan_js" "Pods")

	exclude=""
	for i in ${exclude_files[@]}; do
		exclude=${exclude}"-e "${i}" "
	done
	echo "排除目录：${exclude}"

    # 分析reportType
    if [[ ${reportType} =~ ${REPORT_PMD} ]] 
        then
		nowReportType="pmd -o pmd.xml"
	else    
		nowReportType="xcode"
	fi

	# 生成报表
	oclint-json-compilation-database ${exclude} -- \
	-report-type ${nowReportType} \
	-rc LONG_LINE=200 \
	-disable-rule ShortVariableName \
	-disable-rule ObjCAssignIvarOutsideAccessors \
	-disable-rule AssignIvarOutsideAccessors \
	-max-priority-1=100000 \
	-max-priority-2=100000 \
	-max-priority-3=100000

    rm compile_commands.json
    if [[ ${reportType} =~ ${REPORT_PMD} ]] && [ ! -f ./pmd.xml ]
    then
        echo "-----分析失败-----"
		return -1
    else
	    echo '-----分析完毕-----'
	    return 0
    fi
}

# 替换workspace的名字
myworkspace="cardloan.xcworkspace" 
# 替换scheme的名字
myscheme="cardloan" 
# 输出方式 xcode/pmd
reportType="xcode"

oclintForProject ${myworkspace} ${myscheme} ${reportType}
