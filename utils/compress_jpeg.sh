#!/usr/bin/env bash
# Compress orthorectified GeoTIFFs with internal JPEG, keeping the alpha band as a mask.
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 INPUT_DIR OUTPUT_DIR" >&2
    exit 1
fi

in_dir=$1
out_dir=$2
# Set quality from JPEG_QUALITY environment variable (if exists, otherwise set to 85).
quality=${JPEG_QUALITY:-85}

if [ ! -d "$in_dir" ]; then
    echo "Error: $in_dir is not a directory" >&2
    exit 1
fi

# Compare absolute paths. Don't fail if out_dir doesn't exist yet.
if [ "$(realpath "$in_dir")" = "$(realpath -m "$out_dir")" ]; then
    echo "Error: Output directory must be different from input directory" >&2
    exit 1
fi

# Don't include the pattern as a file.
shopt -s nullglob
files=("$in_dir"/*.tif)

# Verify number of entries in files array.
if [ ${#files[@]} -eq 0 ]; then
    echo "Error: No .tif files in $in_dir" >&2
    exit 1
fi

mkdir -p "$out_dir"

# TODO: allow compression of images without alpha channel.
for f in "${files[@]}"; do
    name=$(basename "$f")
    echo "Compressing $name..."
    gdal_translate -q "$f" "$out_dir/$name" \
        -b 1 -b 2 -b 3 -mask 4 \
        -co COMPRESS=JPEG -co PHOTOMETRIC=YCBCR -co JPEG_QUALITY="$quality" -co TILED=YES \
        --config GDAL_TIFF_INTERNAL_MASK YES
done

echo "Done: ${#files[@]} files written to $out_dir"
