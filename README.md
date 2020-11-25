# Shopping List
Shopping List is a World of Warcraft addon for maintaining a list of items that you need and how many you already have.
The source code and all releases are available on the [GitHub page](https://github.com/Kumodatsu/ShoppingList).
Keep in mind that all version numbers starting with 0 are development versions which may not be tested properly and may give a buggy experience.

## Setup instructions
### How to download
Go to the [releases page](https://github.com/Kumodatsu/ShoppingList/releases).
Find the section of the version you want.
The latest version is always on top.
At the bottom of the section, there is a small "Assets" drop down.
Click on it, then click on "ShoppingList.zip" to download.

### How to install
The downloaded zip file contains a single folder called "ShoppingList".
Drop this folder (not the zip file itself) into your AddOns folder `World of Warcraft\_retail_\Interface\AddOns`.
Now you can run the game.
You can try running the command `/sl version` to check if the addon is working.
If you don't get version information displayed in the chat, something went wrong.
Make sure you put the right folder into the right folder.

### How to make backups
The addon saves your data into `World of Warcraft\_retail_\WTF\Account\<account name>\SavedVariables\ShoppingList.lua`.
To make a backup of your data, copy this file somewhere safe.
To restore the data, copy the backup file back to the aforementioned location.

## Usage (Version 0.1.1)
At the moment, all interactions with the addon happen through commands.
The UI frame only displays the current status of your shopping list.

All commands provided by the addon start with `/sl`.
Alternatively, if this conflicts with other addons, you can use `/shoppinglist` instead of `/sl`.
Use the command `/sl help` to view a listing of all available commands, and `/sl help <command>` to see an explanation of the given command.
`/sl version` displays information about the currently loaded version of the addon.

To make a new shopping list, use the command `/sl new <list name>`.
For example, use `/sl new Alchemy Ingredients` to make a list called "Alchemy Ingredients".
If you have made multiple lists, you can select which one to track using `/sl select <list name>`.
Use `/sl delete <list name>` to delete a list, `/sl current` to display the currently tracked list and
`/sl lists` to display which lists you have.

To add an entry to your shopping list, use the command `/sl add <number> <item name>`.
For example, use `/sl add 20 Talandra's Rose` to add 20 Talandra's Rose to your shopping list.
Use `/sl remove <item name>` to remove an entry from the list and `/sl clear` to clear the entire list.
Finally, use `/sl show` or simply `/sl` to show the shopping list in the chat.

When you have obtained the required number of a specific item, the number for that entry will turn green in the list.
Whenever you receive or lose an item that is on the list, a message will be displayed in the chat showing how many you now have of that item.

Currently, trying to add an item which your character has never encountered before will not work.
This will be fixed in an upcoming version.
