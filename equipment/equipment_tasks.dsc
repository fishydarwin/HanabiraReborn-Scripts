#
# Equipment - a comprehensive RPG item system.
# Inspired by old MMORPGs and Elden Ring.
#
# Structure of an item:
# item_unique_key:
#   itemtype: element
#   # [[ allowed itemtypes in equipment_config ]]
#   material: item
#   name: element
#   description: element
#   stats:
#       atk: element (integer)
#       def: element (integer)
#       agi: element (integer)
#       # ...
#       # [[ and so on for any others ]]
#       # [[ ommit stat to mark as "lv 0" ]]
#   abilities:
#       passive: script_name    # runs a 1 second task (efficiently...) to check for any passive effects.
#       left: script_name       # runs if left click is used while holding
#       right: script_name      # runs if right click is used while holding
#       hotkey: script_name     # runs if hot key is pressed - i.e. the item would be held in the hotbar
#       hit: script_name        # runs upon the target living entity being hit
#       repell: script_name     # runs upon the player being damaged by a living entity source.
#       # [[ all abilities are optional ]
#   allow-duplicates: true/false
#   # [[ most items should allow duplicates, but key items not ]]
#   # [[ if an item has no duplicates, it also cannot be traded ]]
#   weight: element (integer)
#   # [[ weight is used in some calculations to forbid overly-hogging powerful items. ]]
#   # [[ weight calcuation uses player END stat. ]]
#
##
# Some flags are stored on the player automatically and ARE READ-ONLY!
# To modify any of these flags, see the helper functions provided in this file.
# NEVER modify these directly.
#
# equipment_storage:
# # Stores the items a player owns as a list. A sort of virtual inventory.
# # Each entry has the item key associated to a level.
# [ item1:0 , item2:0 , ...]
#
# equipment_current:
# # Stores what the player is currently holding in their physical inventory.
#   main: ...  # main weapon slot 1
#   alt: ...  # alt weapon slot 2
#   cast_1: ...  # spell cast slot 3
#   cast_2: ...  # spell cast slot 4
#   cast_3: ...  # spell cast slot 5
#   off: ...  # offhand item
#   helmet: ...  # helmet armor
#   chestplate: ...  # chestplate armor
#   leggings: ...  # leggings armor
#   boots: ...  # boots armor
#

# creates a usable in-game item from a starter key
# determines output in the first entry on determination. flags must be used, hence a task.
equipment_generate:
    debug: false
    type: task
    definitions: itemkey|itemlevel
    script:
    ## main things
    - define data <script[<[itemkey]>]>
    - define config <script[equipment_config]>
    ## required
    # name and description
    - define name <[data].data_key[name].parse_color>
    - define description <[data].data_key[description].parse_color.strip_color>
    # itemtype
    - define itemtype <[data].data_key[itemtype]>
    - define itemtype_data <[config].data_key[item-types].get[<[itemtype]>]>
    # allow duplicates
    - define allow_duplicates <[data].data_key[allow-duplicates]>
    ## optional
    # stats
    - define stats <[data].data_key[stats].if_null[<map[]>]>
    # abilities
    - define abilities <[data].data_key[abilities].if_null[<map[]>]>
    # weight
    - define weight <[data].data_key[weight].if_null[0]>
    ## generate item
    - define item <[data].data_key[material].parsed>
    - adjust def:item display:<[name]>
    ## make lore
    - define lore <list[]>
    # general description
    - define lore <[lore].include[<&7><[itemtype_data].get[show-as]>]>
    - define lore <[lore].include[<[description].split_lines_by_width[255].split[<&nl>].parse_tag[<&f><&o><[parse_value]>]>]>
    - define lore <[lore].include[<&f>]>
    ## stats if any
    - if <[stats].size> > 0:
        - define lore <[lore].include[<&6>Stats:]>
    - foreach <[stats].keys> as:stat:
        - define lore <[lore].include[<&7><[stat].to_uppercase>:<&sp><[stats].get[<[stat]>]>]>
    - if <[stats].size> > 0:
        - define lore <[lore].include[<&f>]>
    ## store abilities
    - if <[abilities].size> > 0:
        - flag <[item]> equipment_abilities:<[abilities]>
        - define lore <[lore].include[<&6>Abilities:]>
        # generate lore for each ability
        - foreach <[abilities].keys> as:ability:
            - define ability_description <script[<[abilities].get[<[ability]>]>].data_key[description]>
            - define lore <[lore].include[<&7><[ability].to_sentence_case>:]>
            - define lore <[lore].include[<[ability_description].split_lines_by_width[255].split[<&nl>].parse_tag[<&f><&o><[parse_value]>]>]>
        - define lore <[lore].include[<&f>]>
    ## weight if any
    - if <[weight]> > 0:
        - define lore <[lore].include[<&7>Weight:<&sp><[weight]>]>
    - else:
        - define lore <[lore].include[<&7>No<&sp>weight.]>
    ## can duplicate?
    - if !<[allow_duplicates]>:
        - define lore "<[lore].include[<&8>Item cannot be duplicated or sold.]>"
    ## finally set lore
    - adjust def:item lore:<[lore]>
    ## apply stats using attributes where possible.
    - inject __equipment_generate_attributes
    ## hide all vanilla data on it
    - adjust def:item hides:all
    ## add data
    - flag <[item]> equipment_id:<[itemkey]>
    - flag <[item]> equipment_level:<[itemlevel]>
    ## return
    - determine <[item]>

# internal use system to push attribute data upon an item
# should NOT be used by itself - it is meant to be injected.
__equipment_generate_attributes:
    debug: false
    type: task
    script:
    #TODO: change slot: hand to contextual slot from config.
    # modify each stat based on correct info
    # atk
    - if <[stats].contains[atk]>:
        - define attack <[stats].get[atk].sub[1]>
        - definemap attack_map:
            generic_attack_damage:
                1:
                    operation: add_number
                    amount: <[itemlevel].mul[<[attack]>]>
                    slot: hand
        - adjust def:item remove_attribute_modifiers:<list[generic_attack_damage]>
        - adjust def:item add_attribute_modifiers:<[attack_map]>
    # def
    - if <[stats].contains[def]>:
        - define defense <[stats].get[def].sub[1]>
        - definemap defense_map:
            generic_armor:
                1:
                    operation: add_number
                    amount: <[itemlevel].mul[<[defense]>]>
                    slot: hand
        - adjust def:item remove_attribute_modifiers:<list[generic_armor]>
        - adjust def:item add_attribute_modifiers:<[defense_map]>
    # agi
    - if <[stats].contains[agi]>:
        - define agility <[stats].get[agi].sub[1]>
        - definemap agility_map:
            generic_armor:
                1:
                    operation: add_number
                    amount: <[itemlevel].get[agi].mul[<[agility]>]>
                    slot: hand
        - adjust def:item remove_attribute_modifiers:<list[generic_movement_speed]>
        - adjust def:item add_attribute_modifiers:<[agility_map]>
    # end
    - if <[stats].contains[end]>:
        - define endurance <[stats].get[end].sub[1]>
        - definemap endurance_map:
            generic_max_health:
                1:
                    operation: add_number
                    amount: <[itemlevel].get[end].mul[<[endurance]>]>
                    slot: hand
        - adjust def:item remove_attribute_modifiers:<list[generic_max_health]>
        - adjust def:item add_attribute_modifiers:<[endurance_map]>
    # dex - nothing required
    # int - nothing required
    # mnd - nothing required
    # done
