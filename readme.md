# Replicating Robots

Replicating Robots is an attempt at the "self-replicating turtle" challenge for the Computer Craft mod in Minecraft.

![image](readme.png)

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

### Prerequisites

[Yarn package manager](https://yarnpkg.com/)

### Building source

The build steps transpiles the Typescript into Lua to run in ComputerCraft -

`yarn build`

If you're developing -

`yarn dev`

### Syncing to Minecraft

The sync step is used to push the Lua into your Minecraft save -

`echo "/home/jamie/.minecraft/saves/Test/computercraft/computer/1/src/" > .computerDirectory`

`yarn sync`

If you're developing -

`yarn sync:watch`

## License

[MIT](https://choosealicense.com/licenses/mit/)
