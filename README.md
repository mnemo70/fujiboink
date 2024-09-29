FujiBoink! Amiga
================

This is a 1:1 conversion of the 1986 original demo by Michael Park for the
Atari ST.


To generate all the data from scratch you need to:

1. Run convfujis2.py with Python to generate "fujiplanes.raw" that contains
   the animation frames for the Fuji. This also generates single animation
   frames as PNGs and an animated PNG for debugging.
2. Run colorconv.py piping the output to "BoinkColors.i".
3. Load "Boink_sfx_C-3.aki" into AmigaKlang and generate asm source as
   exemusic.asm. The equate "AK_USE_PROGRESS" must be set to 0 afterwards.
4. 