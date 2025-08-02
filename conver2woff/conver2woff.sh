#!/bin/bash

# 提示无权限时执行
# xattr -d com.apple.quarantine subset-fonts.sh

# 用法检查
if [ $# -lt 1 ]; then
  echo "用法: $0 字体文件路径"
  exit 1
fi

FONT="$1"

# 基础名称处理
BASENAME=$(basename "$FONT")
NAME="${BASENAME%.*}"
OUTDIR="./${NAME}"

mkdir -p "$OUTDIR"

# 用两个普通数组存储子集名和对应的 Unicode 范围，保持对应关系
subsets=(
"latin"
"latin-ext"
"punct-symbol"
"sc-cm-1"
"sc-cm-2"
"sc-cm-3"
"sc-cm-4"
"sc-cm-5"
"sc-cm-6"
"sc-cm-7"
"sc-cm-8"
"sc-cm-9"
"sc-cm-10"
"sc-cm-11"
"sc-cm-12"
"sc-cm-13"
"sc-cm-14"
"sc-cm-15"
"sc-cm-16"
"sc-cm-17"
"sc-cm-18"
"sc-cm-19"
"sc-cm-20"
"sc-cm-21"
"sc-cm-22"
"sc-cm-23"
"sc-cm-24"
"sc-cm-25"
"sc-cm-26"
"sc-rare1"
"sc-rare2"
"sc-rare3"
"sc-rare4"
"sc-rare5"
"sc-rare6"
"sc-rare7"
"sc-rare8"
"sc-rare9"
"sc-rare10"
"sc-rare11"
"sc-rare12"
"sc-rare13"
"sc-rare14"
"sc-rare15"
"sc-rare16"
"sc-rare17"
"sc-rare18"
"sc-rare19"
"sc-rare20"
"sc-rare21"
"sc-exta1"
"sc-exta2"
"sc-exta3"
"sc-exta4"
"sc-exta5"
"sc-exta6"
"sc-ucm1"
"sc-ucm2"
"sc-ucm3"
"sc-ucm4"
"sc-ucm5"
"sc-ucm6"
"sc-ucm7"
"sc-ucm8"
"sc-ucm9"
"sc-ucm10"
"sc-ucm11"
"sc-ucm12"
"sc-ucm13"
"sc-ucm14"
"sc-ucm15"
"sc-ucm16"
"sc-ucm17"
"sc-ucm18"
"sc-ucm19"
"tc-zhuyin"
"jp-kana"
"kr-hangul"
"cjk-extb-core"
"cjk-extb-mid"
"cjk-extb-rare"
"cjk-extb-extreme"	
)

ranges=(
"U+0000-00FF"
"U+0100-02FF,U+1E00-1EFF,U+A720-A7FF,U+AB30-AB6F,U+FB00-FB4F"
"U+2000-206F,U+2100-214F,U+2190-21FF,U+2200-22FF,U+25A0-25FF,U+2600-26FF,U+3000-303F,U+FF00-FFEF,U+F900-FAFF"
"U+4E00-4EFF"
"U+4F00-4FFF"
"U+5000-50FF"
"U+5100-51FF"
"U+5200-52FF"
"U+5300-53FF"
"U+5400-54FF"
"U+5500-55FF"
"U+5600-56FF"
"U+5700-57FF"
"U+5800-58FF"
"U+5900-59FF"
"U+5A00-5AFF"
"U+5B00-5BFF"
"U+5C00-5CFF"
"U+5D00-5DFF"
"U+5E00-5EFF"
"U+5F00-5FFF"
"U+6000-60FF"
"U+6100-61FF"
"U+6200-62FF"
"U+6300-63FF"
"U+6400-64FF"
"U+6500-65FF"
"U+6600-66FF"
"U+6700-67FF"
"U+7800-78FF"
"U+7900-79FF"
"U+7A00-7AFF"
"U+7B00-7BFF"
"U+7C00-7CFF"
"U+7D00-7DFF"
"U+7E00-7EFF"
"U+7F00-7FFF"
"U+8000-80FF"
"U+8100-81FF"
"U+8200-82FF"
"U+8300-83FF"
"U+8400-84FF"
"U+8500-85FF"
"U+8600-86FF"
"U+8700-87FF"
"U+8800-88FF"
"U+8900-89FF"
"U+8A00-8AFF"
"U+8B00-8BFF"
"U+8C00-8CFF"
"U+3400-37FF"
"U+3800-3BFF"
"U+3C00-3FFF"
"U+4000-43FF"
"U+4400-47FF"
"U+4800-4BBF"
"U+8D00-8DFF"
"U+8E00-8EFF"
"U+8F00-8FFF"
"U+9000-90FF"
"U+9100-91FF"
"U+9200-92FF"
"U+9300-93FF"
"U+9400-94FF"
"U+9500-95FF"
"U+9600-96FF"
"U+9700-97FF"
"U+9800-98FF"
"U+9900-99FF"
"U+9A00-9AFF"
"U+9B00-9BFF"
"U+9C00-9CFF"
"U+9D00-9DFF"
"U+9E00-9EFF"
"U+9F00-9FFF"
"U+3100-312F,U+31A0-31BF,U+2F00-2FDF"
"U+3040-309F,U+30A0-30FF,U+31F0-31FF"
"U+AC00-D7AF,U+1100-11FF"
"U+20000-21FFF"
"U+22000-23FFF"
"U+24000-25FFF"
"U+26000-2A6DF,U+2A700-2B73F,U+2B740-2B81F,U+2B820-2CEAF,U+2CEB0-2EBEF,U+2F800-2FA1F"
)

for i in "${!subsets[@]}"; do
  subset=${subsets[$i]}
  range=${ranges[$i]}

  echo "生成子集 $subset ($range)"

  pyftsubset "$FONT" \
    --output-file="$OUTDIR/${NAME}-$subset.woff2" \
    --flavor=woff2 \
    --unicodes="$range" \
    --layout-features='*' \
    --glyph-names \
    --legacy-cmap \
    --symbol-cmap \
    --notdef-glyph \
    --notdef-outline \
    --recommended-glyphs \
    --name-IDs='*' \
    --name-legacy \
    --name-languages='*'
done

echo "完成，子集生成在目录 $OUTDIR"
