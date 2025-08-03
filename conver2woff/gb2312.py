import re

def is_cjk_unicode(cp):
    return (
        0x3400 <= cp <= 0x4DBF or
        0x4E00 <= cp <= 0x9FFF or
        0xF900 <= cp <= 0xFAFF or
        0x20000 <= cp <= 0x2A6DF or
        0x2A700 <= cp <= 0x2B73F or
        0x2B740 <= cp <= 0x2B81F or
        0x2B820 <= cp <= 0x2CEAF or
        0x2CEB0 <= cp <= 0x2EBEF or
        0x30000 <= cp <= 0x3134F or
        0x31350 <= cp <= 0x323AF or
        0x2F800 <= cp <= 0x2FA1F
    )

# GB2312 范围
gb2312_start = 0x4E00
gb2312_end = 0x9FA5

# 匹配 U+XXXX 或 U+XXXX–YYYY
pattern = re.compile(r"U\+([0-9A-Fa-f]{4,6})(?:[-–~‒－—﹘﹣]?([0-9A-Fa-f]{4,6}))?")

def filter_match(match):
    start_hex = match.group(1)
    end_hex = match.group(2)

    start_cp = int(start_hex, 16)
    end_cp = int(end_hex, 16) if end_hex else start_cp

    for cp in range(start_cp, end_cp + 1):
        if (is_cjk_unicode(cp) and not (gb2312_start <= cp <= gb2312_end)) or cp > 0xFFFF:
            return ''  # 删除整个编码/区间
    return match.group(0)

# 读取输入文件
with open("gb2312.txt", "r", encoding="utf-8") as f:
    content = f.read()

# 过滤不合要求的编码
filtered = pattern.sub(filter_match, content)

# 保存输出
with open("filtered_unicode_ranges.txt", "w", encoding="utf-8") as f:
    f.write(filtered)

print("✅ 已完成过滤，结果保存为 filtered_unicode_ranges.txt")