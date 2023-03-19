# records the assignment when using /npc assign command.
# this is required to attach the code to the NPC.
dialogue_test_reimu_assign:
    debug: false
    type: assignment
    # the actions key is required for assignment containers
    actions:
        on assignment:
        # enable certain "triggers" for NPCs. this is required for efficient stuff
        - trigger name:click state:true
    # define your interact script(s) here on assignment.
    interact scripts:
    - dialogue_test_reimu

dialogue_test_reimu:
    debug: false
    type: interact
    steps:
        # steps can have up to 4 different triggers (unless an external plugin adds more):
        # click triggers, damage triggers, chat triggers, and proximity triggers
        # 90% of the time you'll want the --click trigger--.
        1:
            click trigger:
                script:
                # perform NPC dialogue here.
                #
                # a dialogue_narrate task is included that types some text and also waits some time for the player to be able to read the message. the player and NPC are not needed to be specified, as they get inferred by Denizen automatically.
                #
                - ~run dialogue_narrate def.format:dialogue_formats_context "def.text:The shrine maiden would appear to stare sternly at the newly appeared face, probably expecting a donation."
                #
                - ~run dialogue_narrate def.format:dialogue_formats_npc "def.text:Hey. How can I help?"
                #
                - ~run dialogue_narrate def.format:dialogue_formats_context "def.text:Despite her words the shrine maiden would seem pretty reluctant to help."
