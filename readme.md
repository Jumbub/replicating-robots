# Replicating Robots

My attempt at the "self-replicating turtle" for the Computer Craft mod in Minecraft.

This mod is where my ~~addiction~~ passion for programming began (back in 2012) so I thought I'd pay homage and complete this more complex challenge.

![image](readme.png)

## Context

A "turtle" (as seen in the above image) is effectively a robot minecraft player.

They provide an extremely simple API - `moveUp`, `placeDown`, `dig`

With the right resources - diamonds, stone, glass, ... - a turtle could craft another turtle.

In this challenge I write a brain for a turtle, with just enough intelligence to gather the required resources to craft some friends.

## Challenge

[Set back in 2012 in the ComputerCraft forums.](http://www.computercraft.info/forums2/index.php?/topic/4462-competition/)

### Rules

- Turtle must acquire all the resources it needs to operate by itself
- Turtle must place a torch near its starting location by full dark
- Turtle must check this torch before nightfall every day, and replace it if missing
- Turtle must acquire all the resources required to build additional crafty mining turtles.
- Must craft two crafty mining turtles, and place them in a chest near the starting location.
- Must place a sign over that chest reading "Complete" when and only when this goal has been met.
- These turtles will be removed by the judge when the "Complete" sign is found.

### Setup

- A crafty mining turtle starts at base of a normal tree in a large oak forest
- The starting tree will be at least 6 blocks tall
- There will be at least one other tree trunk within 8 blocks of the starting tree
- There will be water and at least 6 sand within 16 blocks of the starting tree
- To enable programming more turtles without any other mods, one sugar cane will be - planted by the sand/water. This will be within a 33x33 area centred around the starting tree
- The supplied program will be run at any time during minecraft dawn - after full darkness but before full light

### Configuration

- Vanilla Minecraft, with only the ComputerCraft mod
- No internet access
- Fuel use is enabled
- Player will neither help nor deliberately obstruct the turtle

## Running

### Installing

Replace your turtles rom with: `git clone https://github.com/Jumbub/replicating-robots.git`

### Executing

Inside your turtle, run: `main`
