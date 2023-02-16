#
# Utility for creating menus with click handlers on them.
# It also provides a way to make paged menus more easily.
#

# opens a menu with a title, of size, based on the contents.
# the size must be a multiple of 9
#
# the contents should be a map pairing the slot to three keys
# the 'item' key is the item's display in the menu
# the 'script' key is the script to call when clicked
# the 'definitions' key is a map pairing definition name to value
# if the script is null, then no script is called on interaction
# if the definitions are null, the script is called without definitions
# at the end, after opening, this task determines the opened inventory.
#
# the fill argument can be ommitted, or is an item which fills any
# slots not specified in the contents map
menu_open:
    debug: false
    type: task
    definitions: player|title|size|contents|fill
    script:
    - define display_key <element[menu].to_secret_colors.split[<&ss>].remove[1].parse_tag[<&ss><[parse_value]><&sp>].separated_by[]>
    - define inventory <inventory[generic[title=<[title]><[display_key]>;size=<[size]>]]>
    # fill
    - foreach <[contents]> key:slot as:data:
        - define item <[data].get[item].if_null[null]>
        # bad item
        - if <[item]> == null:
            - foreach next
        # fit other data
        - define script <[data].get[script].if_null[null]>
        - define definitions <[data].get[definitions].if_null[null]>
        # flag item accordingly
        - if <[script]> != null:
            - flag <[item]> _menu_script:<[script]>
        - if <[definitions]> != null:
            - flag <[item]> _menu_definitions:<[definitions]>
        # set in inventory
        - inventory set slot:<[slot]> origin:<[item]> destination:<[inventory]>
    # has fill attribute?
    - if <[fill].if_null[null]> != null:
        - repeat <[size]> as:slot:
            - if !<[contents].contains[<[slot]>]>:
                - inventory set slot:<[slot]> origin:<[fill]> destination:<[inventory]>
    # open inventory and return
    - inventory open player:<[player]> destination:<[inventory]>
    - determine <[inventory]>

# checks if the passed menu parameter is actually
# a menu or not based on its display key
menu_is:
    debug: false
    type: procedure
    definitions: inventory
    script:
    - define display_key <[inventory].title.replace[<&sp>].with[].substring[<[inventory].title.length.sub[23]>].from_secret_colors.if_null[null]>
    - determine <[display_key].equals[menu]>

# determines the title of a menu ignoring its display key
# this also strips any colors to avoid annoyances
# useful for other handlers elsewhere
menu_title:
    debug: false
    type: procedure
    definitions: inventory
    script:
    - determine <[inventory].title.substring[0,<[inventory].title.length.sub[23]>].strip_color.if_null[Unknown]>

# handles basic clicks in menu inventories
menu_click_handler:
    debug: false
    type: world
    events:
        on player clicks item in inventory:
        # ignore non-gui clicks
        ## as of 1.19.2
        - if <context.inventory.inventory_type> != CHEST:
            - stop
        # ignore non menus
        - if !<proc[menu_is].context[<context.inventory>]>:
            - stop
        # valid menu, stop all events
        - determine cancelled passively
        # ignore out of bounds clicks
        - if <context.raw_slot> > <context.inventory.size>:
            - stop
        # handle click if any
        - define script <context.item.flag[_menu_script].if_null[null]>
        - if <[script]> != null:
            - define definitions <context.item.flag[_menu_definitions].if_null[null]>
            - if <[definitions]> == null:
                # run plain script
                - run <[script]>
            - else:
                # run scripts with definitions
                - run <[script]> defmap:<[definitions]>
