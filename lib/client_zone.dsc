#
# Library for showing two different states of a region
# on a world, depending on who is looking.
#

# creates an efficient storage of blocks, tracking only the different blocks between
# the provided memory representations of the two states, then stores it by an ID
#
# all worlds from the locations get removed so that the zone can be used outside context.
# set1 and set2 are dictionaries that have this generic structure:
#   locationtag: materialtag
#
# clones are stored in a structure like so
#   locationtag: materialtag1|materialtag2
client_zone_store:
    debug: false
    type: task
    definitions: world|id|set1|set2
    script:
    - define difference_map <map[]>
    # find differences
    - foreach <[set1]> key:where as:material1:
        - define material2 <[set2].get[<[where]>]>
        - if <[material1]> != <[material2]>:
            - define difference_map <[difference_map].with[<[where]>].as[<[material1]>|<[material2]>]>
    # store
    - define client_zones <server.flag[client_zone].if_null[<map[]>]>
    - flag <server> client_zone:<[client_zones].with[<[world]>,<[id]>].as[<[difference_map]>]>

# deletes a client zone and reverts all clientside blocks related to it to serverside values
client_zone_delete:
    debug: false
    type: task
    definitions: world|id
    script:
    - define difference_map <server.flag[client_zone].get[<[world]>,<[id]>].if_null[null]>
    - if <[difference_map]> == null:
        - debug ERROR "Tried to delete inexistent client zone <[world]>,<[id]>."
        - stop
    # hide for all if visible for some reason
    - foreach <[difference_map]> key:where:
        - showfake cancel <[where]> players:<server.online_players>
    # clear player state
    - foreach <server.players> as:player:
        - define player_client_zones <[player].flag[client_zone]>
        - if <[player_client_zones].contains[<[world]>,<[id]>]>:
            - flag <[player]> client_zone:<[player_client_zones].exclude[<[world]>,<[id]>]>
    # clear server state
    - define client_zones <server.flag[client_zone]>
    - flag <server> client_zone:<[client_zones].exclude[<[world]>,<[id]>]>

#
# Note:
# Players have a flag on them tracking which state they see.
# False means CLOSED (state 1), True means OPEN (state 2).
#
# Please be careful! A player missing the flag is NOT the same as the FALSE state.
# If the flag is NOT set, it means the player is still viewing the SERVERSIDE state.
# If the flag is SET, it means the player is viewing a CLIENTSIDE state.
# The vanilla Denizen flags <PlayerTag.fake_blocks> can help atest this further.
#

# shows the closed state (state 1) of a certain client zone to a player
client_zone_player_close:
    debug: false
    type: task
    definitions: player|world|id
    script:
    - define difference_map <server.flag[client_zone].get[<[world]>].get[<[id]>].if_null[null]>
    - if <[difference_map]> == null:
        - debug ERROR "Tried to show inexistent client zone <[world]>,<[id]> to <[player].name>."
        - stop
    # show the blocks for this player
    - foreach <[difference_map]> key:where as:materials:
        - define material <[materials].get[1]>
        - showfake <[material]> <[where]> players:<[player]> duration:2147483647s
    # mark their state as FALSE
    - flag <[player]> client_zone:<[player_client_zones].with[<[world]>,<[id]>].as[false]>

# shows the open state (state 2) of a certain client zone to a player
client_zone_player_open:
    debug: false
    type: task
    definitions: player|world|id
    script:
    - define difference_map <server.flag[client_zone].get[<[world]>].get[<[id]>].if_null[null]>
    - if <[difference_map]> == null:
        - debug ERROR "Tried to show inexistent client zone <[world]>,<[id]> to <[player].name>."
        - stop
    # show the blocks for this player
    - foreach <[difference_map]> key:where as:materials:
        - define material <[materials].get[2]>
        - showfake <[material]> <[where]> players:<[player]> duration:2147483647s
    # mark their state as TRUE
    - flag <[player]> client_zone:<[player_client_zones].with[<[world]>,<[id]>].as[true]>


# shows the true serverside state of a client zone to a player
client_zone_player_reveal_serverside:
    debug: false
    type: task
    definitions: player|world|id
    script:
    - define difference_map <server.flag[client_zone].get[<[world]>].get[<[id]>].if_null[null]>
    - if <[difference_map]> == null:
        - debug ERROR "Tried to show inexistent client zone <[world]>,<[id]> to <[player].name>."
        - stop
    # show the blocks for this player and mark their state as FALSE
    - foreach <[difference_map]> key:where:
        - showfake cancel <[where]> players:<[player]>
    # flip state
    - flag <[player]> client_zone:<[player_client_zones].exclude[<[world]>,<[id]>]>

# tries to efficiently update client zones for a player
client_zone_update:
    debug: false
    type: task
    defintions: player
    script:
    - define current_world <[player].world>
    - foreach <[player].flag[client_zone].if_null[<map[]>]> key:zone as:state:
        - define split <[zone].split[,]>
        - define world <[split].get[1]>
        - define id <[split].get[2]>
        - if <[world]> == <[current_world]>:
            - if <[state]>:
                - run client_zone_player_close def.player:<[player]> def.world:<[world]> def.id:<[id]>
            - else:
                - run client_zone_player_open def.player:<[player]> def.world:<[world]> def.id:<[id]>

# handles the persistence of client zones
client_zone_persistence:
    debug: false
    type: world
    events:
        after player joins bukkit_priority:monitor:
        - run client_zone_player_update def.player:<player>
        after player changes world bukkit_priority:monitor:
        - run client_zone_player_update def.player:<player>
