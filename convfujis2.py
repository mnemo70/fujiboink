#
# Convert animation frames from FUJIBOIN.D8A.
#
# Converts animation 1:1, i.e. the frames are pre-shifted.
#
# Author: mnemotron
#

import sys
# First: pip install pypng
import png
from apng import APNG, PNG

Left = [0,0,0,1,1,1,2,2,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3]

Right = [6,6,6,6,6,6,6,6,6,5,5,5,5,6,6,7,7,7,8,8,8,9,9,9,9,10,10,10,10,10,10,10]

Heights = [88,89,89,90,90,90,91,91,91,91,91,91,91,90,90,90,89,89,88,88,87,86,86,85,84,83,84,85,86,86,87,88]

# 8 colors as RGB values. Gets indexed by the 3 bitplanes (0-7).
Palette = [
  (0, 0, 0),
  (0, 0, 255),
  (64, 64, 255),
  (128, 128, 255),
  (255, 0, 0),
  (255, 64, 64),
  (255, 128, 128),
  (255, 0, 255)
]

dest_bytes_per_line = 18
bytes_per_plane = dest_bytes_per_line * 92

print(f"dest_bytes_per_line={dest_bytes_per_line} bytes_per_plane={bytes_per_plane}")

# Converts a byte offset into a bitplane to the same byte offset in
# Atari ST image format assuming 3 interleaved bitplanes.
def offset_to_st(offset):
  return (offset // 2) * 6 + (offset & 1)

bitmask = [0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1]
# Get an RGB color tuple at image index and x/y coordinates
def get_col(idx, x, y):
  plane_offset = dest_bytes_per_line * 92
  offs = (idx * 3 * plane_offset) + x // 8 + y * dest_bytes_per_line
  mask = bitmask[x & 7]
  palette_index = (1 if (animdata[offs] & mask) != 0 else 0) + \
                  (2 if (animdata[offs + plane_offset] & mask) != 0 else 0) + \
                  (4 if (animdata[offs + 2 * plane_offset] & mask) != 0 else 0)
  return Palette[palette_index]

# Image: 24 bytes per line
def write_png(idx, filename):
  # image size in pixels
  width = dest_bytes_per_line * 8
  height = 92
  img = []
  for y in range(height):
    row = ()
    for x in range(width):
      row = row + get_col(idx, x, y)
    img.append(row)
  with open(filename, 'wb') as f:
    w = png.Writer(width, height, greyscale=False)
    w.write(f, img)

def write_file(name, bindata):
  with open(name, "wb") as outfile:
    outfile.write(bindata)

with open("st_original/FUJIBOIN.D8A", "rb") as f:
  # Seek to and read animation data
  f.seek(0x1A90, 0)
  data = bytes(f.read(0x1AC1C))
  f.close()

# Prep array of 32 offsets
pix = [0] * 32

# Calculate the offsets into the animation data per frame
# Offset of frame 25 is 0
pix[25] = 0
for j in range(1,32):
  i = (j + 25) & 31
  prev = (i - 1) & 31
  # 6 = 3 * 2 bytes per bitplane word
  # Previous offset + size of the previous image
  pix[i] = pix[prev] + (Right[prev] - Left[prev] + 1) * 6 * (Heights[prev] + 1)
  print(f"Offset {i:02} = 0x{pix[i]:05x} i={i:02} prev={prev:02}")

# num_frames * bytes_per_line * num_lines * num_bitplanes
animdata = [0] * (32 * dest_bytes_per_line * 92 * 3)
print(f"data len={len(data)}")
print(f"animdata len={len(animdata)}")

max_width_words = 0
for i in range(0, 32):
#for i in range(3, 4):
  width_in_words = Right[i] - Left[i] + 1
  max_width_words = max(max_width_words, width_in_words)
  width_in_bytes = width_in_words * 2
  offs = 0
  print(f"Conv image={i:02} width_w={width_in_words:02} width_b={width_in_bytes:02}")

  for y in range(0, Heights[i] + 1):
    # Index to first word, first bitplane of source image "i" line "y"
    source_index = pix[i] + y * width_in_words * 6
    # Index to first word, first bitplane of destination image "i" line "y"
    dest = i * (3 * bytes_per_plane) + y * dest_bytes_per_line

    for x in range(0, width_in_words):
      try:
         # Copy the 3 words for the bitplanes
        animdata[dest] = data[source_index]
        animdata[dest + 1] = data[source_index + 1]
        animdata[dest + bytes_per_plane] = data[source_index + 2]
        animdata[dest + 1 + bytes_per_plane] = data[source_index + 3]
        animdata[dest + 2*bytes_per_plane] = data[source_index + 4]
        animdata[dest + 1 + 2*bytes_per_plane] = data[source_index + 5]

        dest += 2
        source_index += 6
      except IndexError:
        # We've run out of bounds, which must never happen
        print(f"IndexError at i={i} x={x} y={y} source_index={source_index} dest={dest}]")
        sys.exit(0)

dest += 2*bytes_per_plane
print(f"dest={dest} / 0x{dest:x}")
print(f"max_width_bytes={max_width_words*2}")

write_file("fujiplanes.raw", bytes(animdata))

print("Writing PNG images and creating APNG...")
ap = APNG()
for i in range(0,32):
  write_png(i, f"fuji{i:02}.png")
  ap.append_file(f"fuji{i:02}.png", delay=50)
ap.save("fujianim.png")
