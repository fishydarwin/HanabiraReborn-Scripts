# Hanabira Reborn

The current scripts used by Hanabira.
We believe it is useless to keep all our work as proprietary, so instead we have opted to keep it public in case somebody finds it useful.

## License

Our code is licensed under **GNU GPL v3**.

A short rundown of it:
- you can use the code for any purpose
- you can change the code to suit your needs
- you can share the software with friends
- you can share the changes you made
- if you modify the software, it must remain under the same license

In simple terms - you're free to do whatever you want, but since this is free software, your work must also be free software and abide by free software principles.

## Structure

The code is organized into **libraries** and **modules**.

Libraries serve to offer very fundamental and repeated functionalities across a lot of systems. They are located inside the `lib` folder, and each library is one single file. You can tell if a system should be a library if a player has no way to interact with the system directly - i.e. they would never know of its existence in the first place.

Modules are more complex systems that make use of libraries and contain proper behavior. These are systems that players can actually interact with and meaningfully see. Each module contains **its own folder**, inside which there are 5 types of files or folders to help structure code:
- module_tasks: the tasks and procedures used by the module
- module_world: the world event handlers used by the module
- module_commands: the chat commands used by the module
- module_formats: the chat formats used by the module
- module_data: the configuration scripts used by the module

Please retain this structure if you intend to contribute to the project.

## Private functions

To mark private functions use two underscores `__` before your task or procedure scripts.
Because flags cannot use single underscore `_` markers, you are free to decide what system to use for private flags.
