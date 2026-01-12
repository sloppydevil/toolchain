#!/bin/bash
# 代码文档生成器 - 用于软件著作权申请
# 将所有 .gd 和 .tscn 文件合并为一个 Markdown 文档
# 
# 用法: ./gen_doc.sh
# 输出: code_doc.md
# 
# 更新记录:
#   2025-12-29 - 初始版本
#   2026-02-23 - 更新注释说明

# 搜索父目录下的所有 .gd 和 .tscn 文件，排除 addons 目录
# -prune: 跳过 addons 目录
# -exec sh -c: 对找到的文件执行内联脚本
find .. -name "addons" -type d -prune -o \( -name "*.gd" -o -name "*.tscn" \) -exec sh -c '
    for file do
        # 输出文件分隔符和文件名
        echo ""
        echo "---"
        echo "文件: $file "
        echo "---"
        echo ""
        
        # 根据文件类型添加代码块语言标记
        if [[ "$file" == *.gd ]]; then
            printf "```gdscript\n"  # GDScript 语法高亮
        else
            printf "```\n"           # 普通代码块
        fi
        
        # 输出文件内容
        cat "$file"
        printf "\n```\n"
    done
' sh {} + > code_doc.md

