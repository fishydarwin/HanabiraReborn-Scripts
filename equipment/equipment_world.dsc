# handles equipment abilities

equipment_world:
    debug: false
    type: world
    events:
        # passive
        on delta time secondly every:1 bukkit_priority:monitor:
        - foreach <server.online_players> as:player:
            - if <[player].item_in_hand.has_flag[equipment_abilities]>:
                - define passive <[player].item_in_hand.flag[equipment_abilities].get[passive].if_null[null]>
                - if <[passive]> != null:
                    - run <[passive]> def.player:<[player]>
        # left
        on player left clicks block:
        - if <player.item_in_hand.has_flag[equipment_abilities]>:
            - define left <player.item_in_hand.flag[equipment_abilities].get[left].if_null[null]>
            - if <[left]> != null:
                - run <[left]> def.player:<player>
        # right
        on player right clicks block:
        - if <player.item_in_hand.has_flag[equipment_abilities]>:
            - define right <player.item_in_hand.flag[equipment_abilities].get[right].if_null[null]>
            - if <[right]> != null:
                - run <[right]> def.player:<player>
        # hotkey
        on player scrolls their hotbar:
        - define item <player.inventory.slot[<context.new_slot>]>
        - if <[item].has_flag[equipment_abilities]>:
            - define hotkey <player.item_in_hand.flag[equipment_abilities].get[hotkey].if_null[null]>
            - if <[hotkey]> != null:
                - determine cancelled passively
                - run <[hotkey]> def.player:<player>
        # hit
        on player damages entity:
        - if !<context.entity.is_living>:
            - stop
        - if <player.item_in_hand.has_flag[equipment_abilities]>:
            - define hit <player.item_in_hand.flag[equipment_abilities].get[hit].if_null[null]>
            - if <[hit]> != null:
                - run <[hit]> def.player:<player> def.target:<context.entity> def.damage:<context.final_damage>
        # repell
        on entity damages player:
        - if !<context.entity.is_living>:
            - stop
        - if <player.item_in_hand.has_flag[equipment_abilities]>:
            - define repell <player.item_in_hand.flag[equipment_abilities].get[repell].if_null[null]>
            - if <[repell]> != null:
                - run <[repell]> def.player:<player> def.target:<context.entity> def.damage:<context.final_damage>
        #TODO: equipment weight load checking
