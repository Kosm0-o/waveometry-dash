# Waveometry Dash

A Geometry Dash-inspired wave level editor created in Godot that allows players to design, edit, test, save, and share their own custom wave levels.

Created by **Kosm0-o**

---

# Overview

**Waveometry Dash** is a custom-built level editor focused on the wave gameplay style found in rhythm-based platforming games.

The goal of this project was to create a tool that gives players the ability to create their own wave challenges through an accessible and flexible editor. Instead of only playing existing levels, users can become creators by designing their own layouts, experimenting with gameplay ideas, and sharing their creations with others.

Waveometry Dash was built from the ground up in Godot, including the gameplay system, editor interface, object system, saving system, and level management.

The project focuses on providing a complete creation workflow:

1. Create a level
2. Place and customize objects
3. Add gameplay elements and effects
4. Test the level instantly
5. Save the level
6. Share the level with others

---

# Main Features

## Custom Level Editor

The core feature of Waveometry Dash is its built-in level editor.

The editor allows users to create levels without modifying code or project files. Instead, everything is handled through an in-game interface designed specifically for level creation.

Current editor features include:

* Placing objects into levels
* Selecting and modifying placed objects
* Moving and editing level elements
* Organizing objects into categories
* Creating custom layouts
* Testing levels directly from the editor
* Saving and loading custom creations

The editor was designed around fast iteration, allowing creators to quickly experiment with gameplay ideas and immediately test changes.

---

# Wave Gameplay System

Waveometry Dash focuses specifically on wave-style gameplay.

The player controls a continuously moving wave object and changes direction to navigate through obstacles. The goal of the gameplay system is to create challenging and precise movement patterns that can be designed through the editor.

Features include:

* Smooth wave movement
* Adjustable movement speed
* Obstacle-based gameplay
* Custom level testing
* Support for creator-designed challenges

By focusing on one gameplay mode, the project allows the editor and gameplay systems to be more polished and specialized.

---

# Object System

Waveometry Dash uses a custom resource-based object system to manage editor content.

Instead of hardcoding every object individually, objects are stored as reusable resources containing their own information and behavior.

Objects are organized into categories:

* Blocks
* Hazards
* Portals
* Interactables
* Decorations
* Triggers

This system makes it easier to expand the editor by adding new objects without needing to rewrite the core editor logic.

Each object can contain information such as:

* Object type
* Visual appearance
* Gameplay behavior
* Editor settings
* Additional properties

---

# Trigger System

The editor includes a trigger system for creating more dynamic levels.

Triggers allow level creators to change parts of the gameplay experience during a level instead of relying only on static objects.

Examples include:

* Background changes
* Object movement
* Object rotation
* Gameplay effects

The trigger system provides a foundation for creating levels with more variety and progression.

---

# Level Saving System

Waveometry Dash includes a custom level saving and loading system.

Levels are stored as data files rather than being permanently created inside the game scene. This allows levels to be easily saved, transferred, and loaded later.

The saving system stores information such as:

* Object positions
* Object types
* Object properties
* Level settings
* Gameplay information

This allows the editor to rebuild a level from saved data whenever it is loaded.

---

# Level Sharing

Waveometry Dash supports simple file-based level sharing.

Instead of requiring online accounts or servers, levels can be exported as files and shared directly between users.

The workflow is:

1. Create a level in the editor
2. Export the level file
3. Send the file to another player
4. Import the file
5. Play or continue editing the level

This keeps sharing simple, lightweight, and accessible.

---

# Technical Details

Waveometry Dash was created using:

* **Engine:** Godot
* **Programming Language:** GDScript
* **Platforms:** Desktop and Web exports

Major technical systems include:

## Custom Resources

Godot's Resource system is used for storing editor data, including:

* Object definitions
* Music definitions
* Editor assets

This allows content to be separated from the core code and makes the project easier to expand.

## Data-Based Level Architecture

Levels are stored using structured data rather than manually created scenes.

This allows:

* Easy saving and loading
* Sharing between users
* Future expansion
* Efficient level management

## Modular Design

The project was designed around independent systems, including:

* Object management
* Level management
* Editor controls
* Trigger handling
* Resource loading

This structure makes future additions easier and keeps the project organized.

---

# Development Process

Waveometry Dash was created as a challenge to build a complete level creation tool from scratch.

Some of the main goals during development were:

* Learning how professional editors handle assets and data
* Creating reusable systems instead of one-off solutions
* Building a flexible object architecture
* Learning serialization and file management
* Creating a tool that other people can use

A major focus was balancing features and polish. Rather than adding many unfinished systems, development focused on creating a strong foundation with working editor tools and a complete creation workflow.

---

# Design Goals

The main design goals of Waveometry Dash were:

## Accessibility

The editor should allow users to quickly create levels without needing programming knowledge.

## Flexibility

The object and trigger systems should allow creators to experiment with different level ideas.

## Expandability

The project should have a structure that allows future additions, such as more objects, effects, and gameplay features.

## Creativity

The main purpose of the project is to encourage users to create and share their own challenges.

---

# Future Improvements

Possible future additions include:

* More object types
* Additional trigger effects
* More customization options
* Improved editor tools
* More advanced level settings
* Better level browsing
* Community sharing features
* Additional gameplay modes

The current version focuses on establishing the foundation for a full level creation platform.

---

# Controls

## Editor

* Mouse: Select, place, and interact with objects
* Additional controls may vary depending on editor mode

## Playtest

* Mouse input: Control the wave

---

# Installation / Running

Download the latest available build and launch the application.

For web versions, open the provided webpage and allow the game to load.

---

# Credits

## Creator

**Kosm0-o**

## Built With

**Godot Engine**

## Inspiration

Inspired by the creativity and level-building systems of rhythm platforming games, especially the idea of allowing players to become level creators.

---

# Final Notes

Waveometry Dash represents a complete level creation workflow, combining gameplay, editing tools, resource management, saving, and sharing into one project.

The project was built with the goal of creating not only a game, but a tool that allows other people to create their own experiences.

Thank you for checking out **Waveometry Dash**!
