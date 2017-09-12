#!/bin/bash

function oclintForProject () {
	myworkspace=cardloan.xcworkspace # 替换workspace的名字
	myscheme=cardloan # 替换scheme的名字

    # 清除上次编译数据
    if [ -d ./derivedData ];
    then
        echo '-----清除上次编译数据derivedData-----'
        rm -rf ./derivedData
    fi

    xcodebuild clean

    # 生成编译数据
    xcodebuild -workspace cardloan.xcworkspace -scheme cardloan -sdk iphonesimulator -derivedDataPath derivedData -configuration Debug | xcpretty -r json-compilation-database -o compile_commands.json

    if [ -f ./compile_commands.json ]
    then
        echo '-----编译数据生成完毕-----'
    else
        echo "-----生成编译数据失败-----"
        return -1
    fi

    # 生成报表
	oclint-json-compilation-database -e Pods -- \
	-report-type pmd -o pmd.xml \
	-rc LONG_LINE=200 \
    -disable-rule ShortVariableName \
    -disable-rule ObjCAssignIvarOutsideAccessors \
    -disable-rule AssignIvarOutsideAccessors \
	-max-priority-1=100000 \
	-max-priority-2=100000 \
	-max-priority-3=100000

	if [ -f ./pmd.xml ]
	then
        rm compile_commands.json
	    echo '-----分析完毕-----'
	    return 0
	else 
		echo "-----分析失败-----"
		return -1
	fi
}

oclintForProject
