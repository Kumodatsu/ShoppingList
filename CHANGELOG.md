# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Item database containing information about some crafting ingredients.
- List database containing some premade lists for leveling crafting professions.
- Command: `/sl import` to import a list from the database.

## [0.1.1] - 2020-11-25
### Added
- The shopping list UI frame. This shows the current status of your shopping list.
- Keybind for toggling the shopping list frame.
- Support for multiple lists.
- Command: `/sl new`. This creates a new list.
- Command: `/sl select`. This selects the currently active list.
- Command: `/sl current`. This shows which list is currently selected.
- Command: `/sl lists`. This shows which lists you have.
- Command: `/sl delete`. This deletes the specified shopping list.

### Fixed
- Items whose name contain a space can now correctly be removed from the list.
- The shopping list is now correctly initialized when logging in.

## [0.1.0] - 2020-08-26
### Added
- The shopping list. It can be shown in the chat with the `/sl` or `/sl show` command.
- Adding entries to the shopping list using `/sl add <number> <item name>`.
- Removing entries from the shopping list using `/sl remove <item name>`.
- Clearing the shopping list using `/sl clear`.
- Help command `/sl help` that displays the list of commands and `/sl help <command>` that displays the specified command's description.
- Version command `/sl version` that displays addon version information.
- Shopping list entry numbers are displayed in green when the required number of that item is obtained.
- When an item that is on the shopping list is added to or removed from the player's inventory, the current status of that item is displayed in the chat.
- The shopping list is saved globally across all characters.
