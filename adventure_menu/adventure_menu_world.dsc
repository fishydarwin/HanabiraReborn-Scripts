#
# Handles menu opening (yay!)
#

adventure_menu_handler:
    debug: false
    type: world
    events:
        on player right clicks block with:adventure_menu_item using:hand:
        # let's stop this event shall we?
        - determine cancelled passively
        # we need the menu though!
        - run adventure_menu_open def.player:<player>
