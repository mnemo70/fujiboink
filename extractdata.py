#
# Convert FUJIBOIN.D8A to single files.
#
# Author: mnemotron
#

import sys

def write_file(name, bindata):
        with open(name, "wb") as outfile:
                outfile.write(bindata)

f = open("st_original/FUJIBOIN.D8A", "rb")
# Read title picture
data = bytes(f.read(0x1A90))
write_file("titlepic.bin", data)

# Prepare array
conv = [0] * (20*85*4)

print(f"len data={len(data)} conv={len(conv)}")
# Title picture is 20 bytes wide and 85 lines high
# 4 word-wise interleaved bitplanes
# Convert to raw Amiga bitplanes in sequential order
for y in range(0,85):
  for x in range(0,10):
    for b in range(0,4):
      conv[x * 2 + y * 20 + b * (20*85)] = data[b * 2 + x * 8 + (y * 8 * 10)]
      conv[1 + x * 2 + y * 20 + b * (20*85)] = data[1 + b * 2 + x * 8 + (y * 8 * 10)]

write_file("titlepic.raw", bytes(conv))

# Read Fuji animation frames
data = bytes(f.read(0x1AC1C))
write_file("fujidata.bin", data)

# Read shading data
data = bytes(f.read(0x900))
write_file("fujishad.bin", data)

f.close()
