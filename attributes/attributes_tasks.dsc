#
# Attributes - a system to manage player stats, leveling, and scaling
# Player stats:
# ATK Attack - scales up general attack damage
# DEF Defense - scales up general damage absorption
# AGI Agility - scales up movement speed
# END Endurance - scales up maximum HP and stamina
# DEX Dexterity - scales up projectile attack damage
# INT Intelligence - scales up magic attack damage
# MND Mind - scales up magic damage absorption
#
# In player data, stats get stored like so in attributes flag:
#
# attributes:
#
#   atk: decimal
#   def: decimal
#   agi: decimal
#   end: decimal
#   dex: decimal
#   int: decimal
#   mnd: decimal
#
#   level: decimal
#   xp: decimal
#   points: decimal
#

# updates a player's current attributes to scale with their levels
# this applies to any static contexts
attributes_update:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].is_online>:
        - stop
    # basic stuff
    - define stats <[player].flag[attributes]>
    - define level <[stats].get[level].sub[1]>
    # modifiers
    - define level_modifiers <script[attributes_config].data_key[scale-per-level]>
    # modify each stat based on correct info
    # atk
    - define attack <[stats].get[atk].sub[1]>
    - definemap attack_map:
        generic_attack_damage:
            1:
                operation: add_number
                amount: <[level_modifiers].get[atk].mul[<[attack]>]>
    - adjust <[player]> remove_attribute_modifiers:<list[generic_attack_damage]>
    - adjust <[player]> add_attribute_modifiers:<[attack_map]>
    # def
    - define defense <[stats].get[def].sub[1]>
    - definemap defense_map:
        generic_armor:
            1:
                operation: add_number
                amount: <[level_modifiers].get[def].mul[<[defense]>]>
    - adjust <[player]> remove_attribute_modifiers:<list[generic_armor]>
    - adjust <[player]> add_attribute_modifiers:<[defense_map]>
    # agi
    - define agility <[stats].get[agi].sub[1]>
    - definemap agility_map:
        generic_movement_speed:
            1:
                operation: add_number
                amount: <[level_modifiers].get[agi].mul[<[agility]>]>
    - adjust <[player]> remove_attribute_modifiers:<list[generic_movement_speed]>
    - adjust <[player]> add_attribute_modifiers:<[agility_map]>
    # end
    - define endurance <[stats].get[end].sub[1]>
    - definemap endurance_map:
        generic_max_health:
            1:
                operation: add_number
                amount: <[level_modifiers].get[end].mul[<[endurance]>]>
    - adjust <[player]> remove_attribute_modifiers:<list[generic_max_health]>
    - adjust <[player]> add_attribute_modifiers:<[endurance_map]>
    # dex - nothing required
    # int - nothing required
    # mnd - nothing required
    # done

# increments a player's stat level
attributes_increment_stat:
    debug: false
    type: task
    definitions: player|stat
    script:
    # find stat
    - define stat <[stat].to_lowercase>
    - define level_modifiers_keys <script[attributes_config].data_key[scale-per-level].keys>
    - if !<[level_modifiers_keys].contains[<[stat]>]>:
        - stop
    # modify stat
    - define stats <[player].flag[attributes]>
    - define stats <[stats].with[<[stat]>].as[<[stats].get[<[stat]>].add[1]>]>
    - flag <[player]> attributes:<[stats]>
    # update
    - run attributes_update def.player:<[player]>

# decrements a player's stat level
attributes_decrement_stat:
    debug: false
    type: task
    definitions: player|stat
    script:
    # find stat
    - define stat <[stat].to_lowercase>
    - define level_modifiers_keys <script[attributes_config].data_key[scale-per-level].keys>
    - if !<[level_modifiers_keys].contains[<[stat]>]>:
        - stop
    - if <[stats].get[<[stat]>]> <= 1:
        - stop
    # modify stat
    - define stats <[player].flag[attributes]>
    - define stats <[stats].with[<[stat]>].as[<[stats].get[<[stat]>].sub[1]>]>
    - flag <[player]> attributes:<[stats]>
    # update
    - run attributes_update def.player:<[player]>

# sets XP to match correct configuration and levels
# uses some basic maths to correctly display it
attributes_xp_touch:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].is_online>:
        - stop
    # define statistics
    - define stats <[player].flag[attributes]>
    - define level <[stats].get[level]>
    - define xp <[stats].get[xp]>
    # levels
    - define required-xp <script[attributes_config].data_key[required-xp]>
    # clear XP, start from scratch
    # multiple calls are required for proper sync
    - experience player:<[player]> set 0
    - experience player:<[player]> set level <[level]>
    # next level should always just be the maximum percentage mathematically.
    - define next_level <[player].xp_to_next_level>
    - define calculated_xp <[xp].div[<[required-xp].get[<[level]>]>].mul[<[next_level]>]>
    - experience player:<[player]> give <[calculated_xp]>

# gives some XP.
attributes_xp_give:
    debug: false
    type: task
    definitions: player|amount
    script:
    # define statistics
    - define stats <[player].flag[attributes]>
    - define xp <[stats].get[xp].add[<[amount]>]>
    - define level <[stats].get[level]>
    # levels
    - define required-xp <script[attributes_config].data_key[required-xp]>
    # overflow?
    - if <[required-xp].contains[<[level]>]>:
        - define required <[required-xp].get[<[level]>]>
        - if <[xp]> >= <[required]>:
            - define level <[level].add[1]>
            - define xp <[xp].sub[<[required]>]>
            - define stats <[stats].with[level].as[<[level]>]>
    # set
    - define stats <[stats].with[xp].as[<[xp]>]>
    - flag <[player]> attributes:<[stats]>
    # update
    - run attributes_xp_touch def.player:<[player]>

# takes some XP. no underflow allowed
attributes_xp_take:
    debug: false
    type: task
    definitions: player|amount
    script:
    # define statistics
    - define stats <[player].flag[attributes]>
    - define xp <[stats].get[xp].sub[<[amount]>]>
    - define level <[stats].get[level]>
    # underflow?
    - if <[xp]> < 0:
        - define xp 0
    # set
    - define stats <[stats].with[xp].as[<[xp]>]>
    - flag <[player]> attributes:<[stats]>
    # update
    - run attributes_xp_touch def.player:<[player]>

# sets a player's XP
attributes_level_set:
    debug: false
    type: task
    definitions: player|level
    script:
    # define statistics
    - define stats <[player].flag[attributes]>
    # underflow?
    - if <[level]> < 1:
        - define level 1
    # set
    - define stats <[stats].with[level].as[<[level]>]>
    - flag <[player]> attributes:<[stats]>
    # update
    - run attributes_xp_touch def.player:<[player]>
