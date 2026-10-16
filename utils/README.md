# utils

Helper scripts.

## compress_jpeg.sh

Compresses orthorectified GeoTIFFs with internal JPEG compression.

Requires GDAL (`gdal_translate`).

```bash
utils/compress_jpeg.sh INPUT_DIR OUTPUT_DIR
```

- Processes every `*.tif` file in `INPUT_DIR`.
- Writes files with the same names to `OUTPUT_DIR`.
- JPEG quality defaults to 85 and can be overridden with an environment variable:

  ```bash
  JPEG_QUALITY=75 utils/compress_jpeg.sh INPUT_DIR OUTPUT_DIR
  ```

Input files are expected to have 4 bands (RGB + alpha), as produced by
`orthorectify.py` by default. Images generated with `--no-alpha` are not yet supported.
