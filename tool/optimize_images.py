"""
Image optimization and conversion tool for Yahya Mohamed's portfolio.
Converts covers, screenshots, and profile images to WebP according to specs.
"""

import os
import sys
from PIL import Image

ASSETS_DIR = os.path.abspath("assets/images")


def scan_images():
    images = []
    total_bytes = 0
    for root, _, files in os.walk(ASSETS_DIR):
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext in [".png", ".jpg", ".jpeg", ".webp"]:
                full_path = os.path.join(root, f)
                rel_path = os.path.relpath(full_path, ".").replace("\\", "/")
                size = os.path.getsize(full_path)
                total_bytes += size
                try:
                    with Image.open(full_path) as img:
                        w, h = img.size
                        fmt = img.format
                        mode = img.mode
                except Exception as e:
                    w, h = -1, -1
                    fmt = "ERR"
                    mode = str(e)
                images.append(
                    {
                        "path": rel_path,
                        "full_path": full_path,
                        "size": size,
                        "width": w,
                        "height": h,
                        "format": fmt,
                        "mode": mode,
                        "filename": f,
                        "ext": ext,
                    }
                )
    return images, total_bytes


def print_baseline_report():
    images, total_bytes = scan_images()
    print("=" * 80)
    print("PORTFOLIO ASSETS BASELINE SCAN REPORT")
    print("=" * 80)
    print(f"Total image count: {len(images)}")
    print(
        f"Total size: {total_bytes / (1024 * 1024):.2f} MB ({total_bytes:,} bytes)"
    )
    print("\nLargest 10 image files:")
    print("-" * 80)
    images_sorted = sorted(images, key=lambda x: x["size"], reverse=True)
    for i, img in enumerate(images_sorted[:10], start=1):
        print(
            f"{i:2d}. {img['path']:<55} | {img['size']/(1024*1024):.2f} MB ({img['size']/1024:6.1f} KB) | {img['width']}x{img['height']} | {img['format']} ({img['mode']})"
        )

    print("\nAll image files and dimensions:")
    print("-" * 80)
    for i, img in enumerate(images_sorted, start=1):
        print(
            f"{i:2d}. {img['path']:<55} | {img['size']/1024:6.1f} KB | {img['width']}x{img['height']} | {img['format']} ({img['mode']})"
        )
    print("=" * 80)


def convert_all(dry_run=False):
    images, total_bytes = scan_images()
    converted_count = 0
    total_before = 0
    total_after = 0
    conversion_log = []

    for img in sorted(images, key=lambda x: x["path"]):
        # Only convert PNG and JPG
        if img["ext"] not in [".png", ".jpg", ".jpeg"]:
            continue

        src_path = img["full_path"]
        rel_path = img["path"]
        w = img["width"]
        h = img["height"]
        orig_size = img["size"]
        total_before += orig_size

        is_cover = "cover" in img["filename"].lower()
        is_profile = "profile" in img["filename"].lower()

        # Determine target parameters
        if is_cover:
            # Covers: maximum 1600px on the longest side. WebP quality: 80.
            max_dim = 1600
            quality = 80
            scale = min(1.0, max_dim / max(w, h))
            target_filename = "cover.webp"
        elif is_profile:
            # Profile: maximum 1200px height. WebP quality: 85. Preserve transparency.
            quality = 85
            scale = min(1.0, 1200 / h)
            target_filename = "profile.webp"
        else:
            # Gallery screenshots: maximum 1200px on the longest side. WebP quality: 80.
            max_dim = 1200
            quality = 80
            scale = min(1.0, max_dim / max(w, h))
            name_part = os.path.splitext(img["filename"])[0]
            # Standardize names: 01.webp, 02.webp, etc.
            try:
                num = int(name_part)
                target_filename = f"{num:02d}.webp"
            except ValueError:
                target_filename = f"{name_part}.webp"

        target_w = round(w * scale)
        target_h = round(h * scale)
        dest_path = os.path.join(os.path.dirname(src_path), target_filename)

        with Image.open(src_path) as im:
            # Preserve RGBA transparency if present
            if im.mode == "RGBA":
                res = im.resize((target_w, target_h), Image.Resampling.LANCZOS)
            else:
                im_rgb = im.convert("RGB")
                res = im_rgb.resize(
                    (target_w, target_h), Image.Resampling.LANCZOS
                )

            if not dry_run:
                res.save(dest_path, "WEBP", quality=quality, method=6)
                new_size = os.path.getsize(dest_path)
            else:
                import io

                buf = io.BytesIO()
                res.save(buf, "WEBP", quality=quality, method=6)
                new_size = buf.tell()

        total_after += new_size
        converted_count += 1
        dest_rel = os.path.relpath(dest_path, ".").replace("\\", "/")
        reduction = (1 - new_size / orig_size) * 100
        conversion_log.append(
            f"{rel_path} ({w}x{h}, {orig_size/1024:.1f} KB) -> {dest_rel} ({target_w}x{target_h}, {new_size/1024:.1f} KB, -{reduction:.1f}%)"
        )
        print(f"[{converted_count:2d}] {conversion_log[-1]}")

    print("\n" + "=" * 80)
    print(f"CONVERSION SUMMARY ({'DRY RUN' if dry_run else 'EXECUTED'})")
    print("=" * 80)
    print(f"Converted files: {converted_count}")
    print(
        f"Total size before: {total_before / (1024*1024):.2f} MB ({total_before:,} bytes)"
    )
    print(
        f"Total size after:  {total_after / (1024*1024):.2f} MB ({total_after:,} bytes)"
    )
    reduction = (1 - total_after / total_before) * 100
    print(f"Total reduction:   {reduction:.2f}%")
    print("=" * 80)
    return conversion_log


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "convert":
        convert_all(dry_run=False)
    elif len(sys.argv) > 1 and sys.argv[1] == "dry-run":
        convert_all(dry_run=True)
    else:
        print_baseline_report()
