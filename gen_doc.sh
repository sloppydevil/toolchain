# used for copyright generation; code file cat; 2025-12-29;
# find . -name "addons" -type d -prune -o -type f -name "*.gd" -exec sh -c '
# find . -name "addons" -type d -prune -o -name "*.tscn" -exec sh -c '
find . -name "addons" -type d -prune -o \( -name "*.gd" -o -name "*.tscn" \) -exec sh -c '
    for file do
        echo ""
        echo "==================="
        echo "=== 文件: $file ==="
        echo "==================="
        echo ""
        cat "$file"
    done
' sh {} + > code_doc.md

