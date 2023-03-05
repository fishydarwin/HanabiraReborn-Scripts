#
# Utility functions for aiding NPC dialogue.
#

dialogue_narrate:
    debug: false
    type: task
    definitions: format|text
    script:
    # 200 WPM average speed, will give around 5 letters per second, or 0.2 seconds per letter.
    - define wait_time <[text].replace[<&sp>].with[].length.div[15]>
    # minimum cap
    - if <[wait_time]> < 3:
        - define wait_time 3
    # narrate
    - narrate format:<[format]> <[text]>
    # wait the calculated time
    - wait <[wait_time]>s
    - stop
