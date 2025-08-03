import argparse
from fontTools.ttLib import TTFont

def get_unicode_ranges(font_path, font_index=0):
    font = TTFont(font_path, fontNumber=font_index)
    codepoints = set()

    for table in font['cmap'].tables:
        codepoints.update(table.cmap.keys())

    codepoints = sorted(codepoints)

    ranges = []
    start = end = None

    for cp in codepoints:
        if start is None:
            start = end = cp
        elif cp == end + 1:
            end = cp
        else:
            ranges.append((start, end))
            start = end = cp
    if start is not None:
        ranges.append((start, end))

    return ranges

def print_wrapped_ranges_by_character_count(ranges, max_total_chars=128):
    line = []
    total = 0

    for start, end in ranges:
        count = end - start + 1
        if total + count > max_total_chars:
            # 打印当前行并换行
            print(",".join(line))
            line = []
            total = 0
        # 格式化编码区段
        if start == end:
            entry = f"U+{start:04X}"
        else:
            entry = f"U+{start:04X}–U+{end:04X}"
        line.append(entry)
        total += count

    if line:
        print(",".join(line))

def main():
    parser = argparse.ArgumentParser(description="列出字体支持的 Unicode 区段（每行字符总量不超过128）")
    parser.add_argument("font", help="字体文件路径")
    parser.add_argument("-i", "--index", type=int, default=0, help="字体索引（针对 TTC）")
    args = parser.parse_args()

    ranges = get_unicode_ranges(args.font, args.index)
    print_wrapped_ranges_by_character_count(ranges, max_total_chars=128)

if __name__ == "__main__":
    main()