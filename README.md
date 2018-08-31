Erlpyt WIP
=====

**Great erlang tasker for python scripts: erlang-python-tasks**

TIPS:
* currently only periodic tasks without returns
* currently supports only string arguments
* do not use same names for tasks
* using **logging** in python script can cause ugly output. Use print instead.

Build
-----

    $ rebar3 compile

Then in order to work erlport in rebar3 copy some files from python2 to python3:
    
    $ cp _build/default/lib/erlport/priv/python2/erlport/__init__.py _build/default/lib/erlport/priv/python3/erlport/__init__.py 
    $ cp _build/default/lib/erlport/priv/python2/erlport/cli.py _build/default/lib/erlport/priv/python3/erlport/cli.py 
    

Start
-----
    $ erl -pa _build/default/lib/*/ebin

If you prefer to store python scripts outside the root directory (f.e. right outside)
    
    $ erl -pa erlpyt/_build/default/lib/*/ebin
    
Then start application in erlang shell
    
    1> application:start(erlpyt).
    
Using
-----

Take a look at the *src/erlpyt_config.erl* to get idea how to describe tasks. 
Also check *test_module.py* and *another_test_module.py* - python modules which acts as tasks logic

Todo
-----
* better work with tasks, which not have their python tasks module or function
* save python consoles for tasks (now it takes time to start them)
* unit tests
* functional tests
    * check task changing when change python modules
    * check task changing when adding python module and modify tasks