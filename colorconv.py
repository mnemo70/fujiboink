#
# Convert FUJIBOIN.D8A color tables to Amiga.
# Also generate the rainbow color table.
# Output as text to console, formatted for Assembler.
#
# Author: mnemotron
#

import sys

shades = [
     0x003, 0x113, 0x114, 0x115, 0x116, 0x117, 0x027, 0x037,
     0x047, 0x057, 0x157, 0x267, 0x367, 0x377, 0x477, 0x577,
     0x677, 0x677, 0x777   
]

NUMSHADES = len(shades)

# color table to fade title screen to red and white...
couleurs = [
  [0x777, 0x766, 0x056, 0x056, 0x700, 0x700, 0x740, 0x740, 0x005, 0x005],
  [0x777, 0x755, 0x256, 0x245, 0x722, 0x700, 0x752, 0x730, 0x225, 0x204],
  [0x777, 0x744, 0x466, 0x434, 0x744, 0x700, 0x764, 0x720, 0x446, 0x403],
  [0x777, 0x722, 0x667, 0x622, 0x766, 0x700, 0x776, 0x710, 0x667, 0x602],
  [0x777, 0x700, 0x777, 0x700, 0x777, 0x700, 0x777, 0x700, 0x777, 0x700]
]

# s in 0..99
def shade(s):
        try:
                return shades[(s * NUMSHADES) // 100]
        except IndexError:
                print(f"shade({s}) IndexError")
                sys.exit(0)

def hexdump(arr):
        i = 0
        s = ""
        for x in arr:
                if i == 8:
                        print(f"\tdc.w\t{s}")
                        i = 0
                        s = ""
                if i > 0:
                        s += ","
                s += f"${x:03x}"
                i += 1

        if i > 0:
                print(f"\tdc.w\t{s}")

def to_amiga(c):
        return c << 1

f = open("st_original/FUJIBOIN.D8A", "rb")
f.seek(0x1C6AC)
data = f.read(0x900)
f.close()

def calc_fuji_colors():
        barkolor = [0] * 32
        kolors = [0] * (32*72)

        iz = 0
        view = 25
        for i in range(0, 32):
                #print(f"data[{iz}]={data[iz]} - set barkolor")
                barkolor[view] = to_amiga(shade(((data[iz] & 255) * 100) // 512))
                for j in range(0, 72):
                        try:
                                #print(f"data[{iz}]={data[iz]} -- set kolors")
                                kolors[view * 72 + j] = to_amiga(shade(((data[iz] & 255) * 100) // 256))
                        except IndexError:
                                print(f"IndexError: view={view} j={j} iz={iz}")
                                sys.exit(0)
                        iz += 1
                view += 1
                if view == 32:
                        view = 0

#        kolors[26 * 72 + 1] = to_amiga(couleurs[0][1]) # 0*10 + 1

        print(";Colors for the middle bar")
        print("barcolors:")
        hexdump(barkolor)

        print(";Colors for the various Fuji views, 72 lines per view")
        print("fujicolors:")
        hexdump(kolors)

def calc_rainbow():
        rainbow = [0] * (8*8*8)
        n = 0
        for r in range(0,8):
                for g in range(0,8):
                        for b in range(0,8):
                                rainbow[n] = to_amiga(((r * 3) & 7) * 256 + b*16 + g)
                                n += 1

        print(";Colors for the rainbow")
        print("rainbowcolors:")
        hexdump(rainbow)

print(";shade(10) result, color for the inner 'far' side of the Fuji")
shade10value = to_amiga(shade(10))
print(f"shade10\tequ\t${shade10value:03x}")

calc_fuji_colors()
calc_rainbow()
