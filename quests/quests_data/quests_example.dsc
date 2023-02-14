quests_quest_example:
    debug: false
    type: data
    # This is used in messages and GUI sometimes
    name: Example Quest
    description: This quest is an example of what a quest should look like
    # The start script is called right before the quest begins.
    start_script: quests_quest_example_start
    # The exit script is called as soon as the quest was finished.
    exit_script: quests_quest_example_exit
    # The clean script is called if a player quits mid-quest, server crashes, etc.
    clean_script: quests_quest_example_clean
    # The steps of the quest - these are ORDERED.
    steps:
        some_step_1: The description of step 1.
        some_step_2: The description of step 2.
        # and so on...
    # The GUI material display & lore is generated automatically
    # The rest you must specify as a mechanism if desired.
    gui_material: stone

quests_quest_example_start:
    debug: false
    type: task
    # this definition must only contain a player
    definitions: player
    script:
    - narrate targets:<[player]> QuestStart!

quests_quest_example_exit:
    debug: false
    type: task
    # this definition must only contain a player
    definitions: player
    script:
    - narrate targets:<[player]> QuestExit!

quests_quest_example_clean:
    debug: false
    type: task
    definitions: player
    script:
    - narrate targets:<[player]> "This script is called on cleanup after crashes or such."

quests_quest_example_handler:
    debug: false
    type: world
    events:
        on player breaks block:
        # right quest?
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_example:
            - stop
        # right step?
        - if <proc[quests_active_step].context[<player>]> == some_step_1:
            # do whatever...
            - narrate "Doing something!"
            # move to next step...
            - run quests_next def.player:<player>
        - else if <proc[quests_active_step].context[<player>]> == some_step_2:
            # do whatever...
            - narrate "Doing something else!"
            # move to next step...
            - run quests_next def.player:<player>
            # since this is the last step, it will automatically finish the quest!
            # that means exit code is called.
