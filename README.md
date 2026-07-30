# Waveometry Dash

A Geometry Dash-inspired wave level editor built in Godot that allows players to create, edit, and share their own wave-based levels.

## Overview

Waveometry Dash is a level creation tool focused on making custom wave gameplay easier and more accessible. Inspired by the wave gameplay style from rhythm platformers, this project provides an editor where users can place objects, design challenges, customize levels, and playtest their creations.

The goal of this project was to create a standalone editor experience where users can experiment with level design without needing to use a complicated external tool. Everything from object placement to level data management was built specifically for this project.

## Features

### Level Editor

The core of the project is a custom-built level editor that allows users to create their own levels from scratch.

Features include:

* Object placement and editing
* Object selection and manipulation
* Multiple object categories
* Customizable level elements
* Trigger-based level changes
* Level playtesting directly from the editor
* Saving and loading custom levels

The editor is designed around quickly iterating on ideas, allowing creators to place objects, test gameplay, and immediately make changes.

## Wave Gameplay

The project focuses on the wave movement style, where players control a continuously moving object through obstacles by changing its direction.

The gameplay system includes:

* Smooth wave movement
* Adjustable level speed
* Obstacles and hazards
* Gameplay testing inside created levels
* Support for custom-designed challenges

The goal is to provide the tools necessary for creating interesting movement patterns and challenging levels.

## Object System

The editor uses a custom resource-based object system.

Objects are separated into categories, allowing the editor to easily organize and manage different types of level elements.

Current categories include:

* Blocks
* Hazards
* Portals
* Interactables
* Decorations
* Triggers

Each object contains its own data, allowing new objects to be added without needing to rewrite large parts of the editor.

## Trigger System

Levels can contain triggers that modify gameplay elements during gameplay.

Examples include:

* Movement changes
* Background changes
* Object rotations
* Other level effects

The trigger system allows creators to make levels that change dynamically instead of being made only from static objects.

## Level Saving and Sharing

Levels are saved as custom data files, allowing creations to be exported and shared with other players.

The sharing system is designed around simple file-based sharing:

1. Create a level
2. Export the level file
3. Send it to another person
4. Import the file into the editor
5. Play and modify the level

This approach keeps sharing simple and allows levels to be transferred without requiring accounts or online servers.

## Technical Details

This project was created using:

* Engine: Godot
* Language: GDScript
* Platform Support: Desktop and Web exports

The editor uses:

* Custom Godot Resources for object definitions
* JSON-based level saving
* Resource databases for loading editor content
* Modular systems for objects, triggers, and levels

The project was designed to be expandable, allowing additional objects, triggers, and features to be added in the future.

## Development Process

This project was created as a challenge to build a complete level editor from the ground up.

Some of the main development goals were:

* Learning how professional editors handle assets and data
* Creating reusable systems instead of hardcoding features
* Building a flexible object architecture
* Understanding serialization and exporting
* Making a tool that is usable by other people, not just a prototype

A major focus was balancing feature scope with polish. Instead of adding many unfinished systems, development focused on creating a solid editor foundation.

## Future Improvements

Possible future additions include:

* More gameplay objects
* More trigger types
* Improved level browsing
* More customization options
* Community level sharing
* Additional gameplay modes
* Better editor tools and quality-of-life improvements

## Controls

### Editor

* Mouse: Select and place objects
* In-Game For More controls

### Playtest

* Click

## Installation / Running

Download the latest build and run the executable.

For web versions, open the provided webpage and allow the game to load.

## Credits

Created by:

Kosm0-o

Built with Godot.

Inspired by Geometry Dash.

## License

None

## Final Notes

This project represents a complete custom level editing workflow, from designing objects and gameplay systems to creating, saving, exporting, and sharing levels.

Thank you for checking out Waveometry Dash!
