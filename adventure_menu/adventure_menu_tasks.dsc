#
# Handles all adventure menu tasks
#

# omg let's finally open the menu quirkyyy
adventure_menu_open:
    debug: false
    type: task
    definitions: player
    script:
    # let's make sure no inventory is open
    - run adventure_menu_close def.player:<[player]>
    # ok good
    #
    # let's define some items
    #
    # first player head
    - define player_head <item[player_head]>
    - adjust def:player_head skull_skin:<player.name>
    - adjust def:player_head "display:<&6>Your Stats"
    - adjust def:player_head "lore:<list[<&7>Click to see your current stats and level.]>"
    # then enchanted book
    - define enchanted_book <item[enchanted_book]>
    - adjust def:enchanted_book "display:<&6>Completed Quests"
    - adjust def:enchanted_book "lore:<list[<&7>See your completed quests and progression.]>"
    # then filled map
    - define filled_map <item[filled_map]>
    - adjust def:filled_map "display:<&6>Your House"
    - adjust def:filled_map "lore:<list[<&7>Click to visit your plot.]>"
    # let's define the contents
    - definemap contents:
        12:
            item: <[player_head]>
            script: adventure_menu_show_stats
            definitions:
                player: <[player]>
        15:
            item: <[enchanted_book]>
            script: adventure_menu_show_quests
            definitions:
                player: <[player]>
        16:
            item: <[filled_map]>
            script: adventure_menu_not_implemented
            definitions:
                player: <[player]>
    # let's open this bad boy up
    - run menu_open def.player:<[player]> "def.title:Adventure Menu" def.size:27 def.contents:<[contents]> def.fill:adventure_menu_fill_item

# close this bad boy
adventure_menu_close:
    debug: false
    type: task
    definitions: player
    script:
    - inventory close player:<[player]>

# literally every other item
adventure_menu_not_implemented:
    debug: false
    type: task
    definitions: player
    script:
    - playsound <[player].location> <[player]> sound:entity_enderman_teleport pitch:0.5
    - narrate "<&c>Sorry, this is not implemented yet." targets:<[player]>

# this is going to open up the stats menu
adventure_menu_show_stats:
    debug: false
    type: task
    definitions: player
    script:
    # first let's close the menu
    - run adventure_menu_close def.player:<[player]>
    # ok fill the slots
    - definemap contents:
        11:
            item: <item[adventure_menu_null_item]>
            script: adventure_menu_not_implemented
            definitions:
                player: <[player]>
        23:
            item: <item[adventure_menu_return_item]>
            script: adventure_menu_open
            definitions:
                player: <[player]>
    # ok open menu
    - run menu_open def.player:<[player]> "def.title:Your Stats" def.size:27 def.contents:<[contents]> def.fill:adventure_menu_fill_item

# open up the quests menu
adventure_menu_show_quests:
    debug: false
    type: task
    definitions: player
    script:
    # first let's close the menu
    - run adventure_menu_close def.player:<[player]>
    # ok fill the slots
    - definemap contents:
        11:
            item: <item[adventure_menu_null_item]>
            script: adventure_menu_not_implemented
            definitions:
                player: <[player]>
        50:
            item: <item[adventure_menu_return_item]>
            script: adventure_menu_open
            definitions:
                player: <[player]>
    # quest_slot first slot that will be empty is 12
    - define quest_slot 11
    # the space is a 7 by 4 "table"
    - repeat 4 as:row:
      - repeat 7 as:column:
        # define your item here...
        - definemap quest_item:
            item: air
        # update the contents
        - define contents <[contents].with[<[quest_slot]>].as[<[quest_item]>]>
        # move to the next slot to the right
        - define quest_slot <[quest_slot].add[1]>
      # avoid the borders: after slot 17 next is 20, so add 2
      - define quest_slot <[quest_slot].add[2]>
    # ok open menu
    - run menu_open def.player:<[player]> "def.title:Completed Quests" def.size:54 def.contents:<[contents]> def.fill:adventure_menu_fill_item