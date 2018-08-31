Erlpyt
=====

**Great erlang tasker for python scripts: erlang-python-tasks**

TIPS:
* currently supports only string arguments
* do not use same names for tasks
* using **logging** in python script can cause ugly output. Use print instead.

Build
-----

    $ rebar3 compile

Todo
-----
* better work with tasks, which not have their python tasks module or function
* save python consoles for tasks (now it takes time to start them)
* unit tests
* functional tests
    * check task changing when change python modules
    * check task changing when adding python module and modify tasks