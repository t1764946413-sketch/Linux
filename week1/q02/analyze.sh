#!/bin/bash
  # analyze.sh — 统计 HTTP 5xx 最多的前 2 个 path 及平均延迟
  # 用法: bash analyze.sh <csv文件路径>

  csv_file="$1"

  # 1) 文件不存在：报错写入 stderr 并返回非零退出码
  if [ ! -f "$csv_file" ]; then
      echo "错误: 文件 '$csv_file' 不存在" >&2
      exit 1
  fi

  # 2) 统计 5xx 状态码最多的前 2 个 path
  echo "HTTP 5xx 数量最多的前 2 个 path:"
  awk -F, '
      NR > 1 && $4 ~ /^5[0-9][0-9]$/ { count[$3]++ }
      END { for (p in count) print count[p], p }
  ' "$csv_file" |
  sort -k1,1nr -k2,2 |
  head -2 |
  awk '{ print $2, $1 }'

  # 3) 平均 latency_ms（跳过表头，保留两位小数）
  echo
  echo "平均 latency_ms:"
  awk -F, '
      NR > 1 { sum += $5; n++ }
      END { if (n > 0) printf "%.2f\n", sum / n }
  ' "$csv_file"

