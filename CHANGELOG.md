# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
