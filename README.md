# PCB Puzzle Game
A puzzle game about drawing PCBs (Printed Circuit Boards). My first game with Godot.

## Demo
 **IMPORTANT!** This isn't a full game (yet)
 
 [Play the demo on Github Pages](https://hekinav.github.io/godot-test/pcb-puzzle).
 
 **Controls**
 
 LMB: Draw traces and move components
 
 RMB: Erase traces
## Known bugs
- Sometimes erasing traces leaves one-tile dots that don't update
  - More common in the web version
  - Seems to be random
## Main features
 Dynamic level grid system
 - Loads from JSON
 - Automatically calculates scale for all components

 Electricity
 - Checks connections between components
 - Makes the traces and components activate visually when they are powered
 - Prevents the player from shorting two nets
## Inspiration
I wanted to learn to use Godot and didn't want to do a simple platformer gane, so I built something more unique.
