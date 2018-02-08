# oclint_apply

使用oclint检测代码，在学习的过程中，为了方便写的一些脚本

```
# 替换workspace的名字
myworkspace="cardloan.xcworkspace" 
# 替换scheme的名字
myscheme="cardloan" 
# 输出方式 xcode/pmd
reportType="xcode"

# 自定义排除警告的目录，将目录字符串加到数组里面，结果中将不会含有Pods文件夹下文件编译警告
exclude_files=("cardloan_js" "Pods")
```

1. Using OCLint in Xcode => 输出方式 xcode
2. Using OCLint with Jenkins CI => 输出方式 pmd\
