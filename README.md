FujiBoink! Amiga
================

This is a 1:1 conversion of the original "FujiBoink!" demo for Atari ST by Michael Park
for Xanth Computers in 1986.

The demo was programmed in Visual Studio Code with the Amiga Assembly extension
by Paul Raingeard.

![A screenshot of this FujiBoink demo on the Amiga showing the Atari logo on a red and white
chequered background and the logo of Xanth Computers below it.](boink-screenshot.png "FujiBoink screenshot")

To generate all the data from scratch you need to:

1. Run convfujis2.py with Python to generate "data/fujiplanes.raw" that contains
   the animation frames for the Fuji. This also generates single animation
   frames as PNGs and an animated PNG for debugging.
2. Compress fujiplanes.raw with zx0 to generate "fujiplanes.raw.zx0".
3. Run colorconv.py piping the output to "BoinkColors.i".
4. Load "Boink_sfx_C-3.aki" into AmigaKlang and generate asm source as
   exemusic.asm. The equate "AK_USE_PROGRESS" must be set to 0 afterwards.
5. Assemble in Visual Studio Code. The executable should be generated in the folder uae/dh0.
