# Handles updating in different worlds.
# Assign default stats if missing any.
# Stops anything related to XP and XP orbs.
# Does projectile damage calculations

attributes_world:
    debug: false
    type: world
    events:
        ## update stats, and set initial data if missing
        after player joins:
        # initial data
        - if !<player.has_flag[attributes]>:
            - definemap attribute_data:
                level: 1
                xp: 0
                points: 0
                atk: 1
                def: 1
                agi: 1
                end: 1
                dex: 1
                int: 1
                mnd: 1
            - flag <player> attributes:<[attribute_data]>
        # update stats
        - run attributes_update def.player:<player>
        - run attributes_xp_touch def.player:<player>
        ## update stats in some extra cases.
        after player changes world:
        - run attributes_update def.player:<player>
        - run attributes_xp_touch def.player:<player>
        after player respawns:
        - run attributes_update def.player:<player>
        - run attributes_xp_touch def.player:<player>
        ## prevent XP from existing.
        # fast blanket cleanup
        on experience_orb prespawns:
        - determine cancelled
        # backup
        on experience_orb spawns:
        - determine cancelled
        on experience bottle breaks:
        - determine cancelled passively
        - remove <context.entity>
        on player absorbs experience:
        - determine cancelled passively
        - remove <context.entity>
        ## projectile damage calculation using DEX
        after projectile hits entity:entity bukkit_priority:monitor:
        # allowed?
        - if <context.cancelled>:
            - stop
        # was an enemy hit?
        - if <context.hit_entity.if_null[null]> == null:
            - stop
        # was player who shot?
        - define player <context.shooter.if_null[null]>
        - if <[player]> == null:
            - stop
        - if !<[player].is_player>:
            - stop
        # handle extra stat damage
        - define stats <[player].flag[attributes]>
        - define level <[stats].get[level].sub[1]>
        # modifiers
        - define level_modifiers <script[attributes_config].data_key[scale-per-level]>
        # calculate dexterity
        - define dexterity <[stats].get[dex]>
        - define dexterity <[level_modifiers].get[dex].mul[<[dexterity]>].mul[2]>
        # apply
        - hurt <[dexterity]> <context.hit_entity> cause:projectile source:<[player]>
        - narrate <[dexterity]> targets:<[player]>
        - narrate <context.hit_entity.health> targets:<[player]>
