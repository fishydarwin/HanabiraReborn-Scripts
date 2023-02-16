#
# Handles menu opening (yay!)
#

adventure_menu_handler:
    debug: false
    type: world
    events:
        on player right clicks block with:adventure_menu_item using:hand:
        # zon't know how it would have gotten past but let's cancel that shit
        - if <player.item_in_hand.as_item> != adventure_menu_item:
            - stop
        # let's stop this event shall we?
        - determine cancelled passively
        # we need the menu though!
        - run adventure_menu_open def.player:<player>
