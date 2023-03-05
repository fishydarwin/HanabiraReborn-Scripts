## Organizing Dialogue Data

### Namespaces

It is required for organization's sake to put all dialogues in this folder, abd for each "system" or "dialogue" to have its own folder, called a "namespace", with the dialogue interaction scripts.

When creating the namespaces, prefix them with an integer which represents their current order. This helps us track when the file was created and have a vague temporal logic to the dialogues.

Some common cases:
- Dialogues for a quest would go in the **(number)_quests_quest_(quest-name)** folder.
- Dialogues for some NPC would go in the **0_generic** folder.
- Dialogues for the NPCs in a specific place might go in the **(number)_(where)** folder.

### Special namespaces

There are two special namespaces:
- **0_generic** - a namespace where extremely short 1-3 line NPC dialogues usually go.
- **1_misc** - a namespace where completely unrelated dialogues (easter eggs etc.) live.

### Naming script files

No matter the namespace, all dialogue scripts have the **dialogue_** prefix attached. Consider the example: `dialogue_quest_example_shrine_maid` for "Reimu's dialogue in the Example quest".

The scripts file names should be suggestive, and can be whatever the developer considers helpful. 

If you are still in need of a naming scheme, we provide the following cases:
- Dialogue that is completely locked to a quest: **dialogue_quest_(...)**. (e.g. `dialogue_quest_example_shrine_maid`)
- Dialogue that is attached to an NPC, should be suffixed with the NPC's location and occupation: **dialogue_(where)_(who)**. (e.g. `dialogue_hana_fisherman`)
- Every other case is simply required to use **dialogue_** as a prefix.

## Agnostic Design

Dialogues are considered NPC-agnostic, so they should not depend on specific NPCs. That is to say, if I'd like to assign the dialogue to **another** NPC, it should work identically, except for the NPC name being swapped.

Under this guise, it is also not recommended to name folders after NPCs, or after NPC IDs.
