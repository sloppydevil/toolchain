#!/usr/bin/env python3
"""
Markdown 转 HTML 工具（用于软著材料生成）
用法: python md2html.py <input.md> [-t TITLE] [-o OUTPUT]
示例:
  python md2html.py design.md
  python md2html.py design.md -t "曼巴回廊软件 V1.0"
  python md2html.py design.md -t "文档标题" -o output.html
"""

import sys
import os
import re
import argparse
from datetime import datetime

try:
    import markdown
except ImportError:
    print("请先安装 markdown 库: pip install markdown")
    sys.exit(1)


def get_title_from_md(content: str) -> str:
    """从 markdown 内容中提取标题"""
    match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
    if match:
        return match.group(1).strip()
    return "文档"


def generate_html(md_content: str, title: str, date: str) -> str:
    """生成带页眉的 HTML"""
    
    md = markdown.Markdown(extensions=['tables', 'fenced_code', 'toc'])
    body_html = md.convert(md_content)
    
    css = """
    <style>
        /* 打印样式 */
        @media print {
            @page {
                margin: 1in;
                @top-center {
                    content: \"""" + title + """ - 页码: " counter(page) " - 日期: """ + date + """"; font-size: 10pt; color: #666; }
            }
        }
        
        /* 基础样式 */
        body {
            font-family: "SimSun", "宋体", serif;
            font-size: 12pt;
            line-height: 1.8;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
        }
        
        /* 标题样式 */
        h1 { font-size: 22pt; text-align: center; border-bottom: 2px solid #333; padding-bottom: 10px; }
        h2 { font-size: 18pt; border-bottom: 1px solid #999; padding-bottom: 5px; margin-top: 30px; }
        h3 { font-size: 14pt; margin-top: 20px; }
        h4 { font-size: 12pt; margin-top: 15px; }
        
        /* 段落样式 */
        p { text-indent: 2em; margin: 10px 0; text-align: justify; }
        
        /* 列表样式 */
        ul, ol { margin: 10px 0; padding-left: 2em; }
        li { margin: 5px 0; }
        
        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            font-size: 11pt;
        }
        th, td {
            border: 1px solid #333;
            padding: 8px 12px;
            text-align: left;
        }
        th {
            background-color: #f0f0f0;
            font-weight: bold;
            text-align: center;
        }
        td { text-align: left; }
        
        /* 代码块样式 */
        pre {
            background-color: #f5f5f5;
            padding: 15px;
            overflow-x: auto;
            font-size: 10pt;
            border: 1px solid #ddd;
            margin: 15px 0;
        }
        code {
            font-family: "Consolas", "Monaco", monospace;
            font-size: 10pt;
        }
        
        /* 图片样式 */
        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 10px auto;
        }
        
        /* 分隔线 */
        hr {
            border: none;
            border-top: 1px solid #999;
            margin: 20px 0;
        }
        
        /* 强调 */
        strong { font-weight: bold; }
        em { font-style: italic; }
        
        /* 块引用 */
        blockquote {
            border-left: 3px solid #999;
            padding-left: 15px;
            margin: 15px 0;
            color: #666;
        }
    </style>
    """
    
    html = f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    {css}
</head>
<body>
{body_html}
</body>
</html>
"""
    return html


def main():
    parser = argparse.ArgumentParser(
        description='Markdown 转 HTML 工具（用于软著材料生成）',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''示例:
  python md2html.py design.md
  python md2html.py design.md -t "曼巴回廊软件 V1.0"
  python md2html.py design.md -o output.html
'''
    )
    parser.add_argument('input', help='输入的 markdown 文件路径')
    parser.add_argument('-t', '--title', help='文档标题（显示在页眉），默认从 markdown 中提取')
    parser.add_argument('-o', '--output', help='输出的 HTML 文件路径，默认为同目录同名文件')
    
    args = parser.parse_args()
    
    input_file = args.input
    if not os.path.exists(input_file):
        print(f"错误: 找不到文件 {input_file}")
        sys.exit(1)
    
    output_file = args.output if args.output else os.path.splitext(input_file)[0] + ".html"
    
    with open(input_file, 'r', encoding='utf-8') as f:
        md_content = f.read()
    
    title = args.title if args.title else get_title_from_md(md_content)
    date = datetime.now().strftime("%Y-%m-%d")
    
    html_content = generate_html(md_content, title, date)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"✅ 已生成: {output_file}")
    print(f"   标题: {title}")
    print(f"   日期: {date}")


if __name__ == "__main__":
    main()
