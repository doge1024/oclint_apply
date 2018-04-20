# oclint_apply

使用oclint检测代码，在学习的过程中，为了方便写的一些脚本

```
# 替换workspace的名字
myworkspace="test.xcworkspace" 
# 替换scheme的名字
myscheme="test" 
# 输出方式 xcode/pmd/html
reportType="xcode"

# [自定义report](http://docs.oclint.org/en/stable/howto/selectreporters.html) 如：
nowReportType="-report-type html -o oclint_result.html"

# 自定义排除警告的目录，将目录字符串加到数组里面，结果中将不会含有Pods文件夹下文件编译警告
exclude_files=("test_js" "Pods")
```

1. Using OCLint in Xcode => 输出方式 xcode
2. Using OCLint with Jenkins CI => 输出方式 pmd
