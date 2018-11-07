%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Aug 2018 17:49
%%%-------------------------------------------------------------------
-author("m.shikhragimov@gmail.com").


%% @doc here is a config record. It is based on types (see erl_pt_types. The
%% declaration is as follows period time in milliseconds, python module of task,
%% function of task, arguments

-record(task, {
  tasks = [{
    test1, {
      9000,
      test_module,
      test_function,
      [
        "qqq",
        "www"
      ]
    }
  },
  {
    test2, {
      19000,
      test_module,
      test_function,
      ["!!!!!!!!!!!!!!!!", "????????????????"]
    }
  },
    {
    test3, {
      19000,
      'python_modules.another_test_module',
      test_function,
      ["1", "2"]
    }
  }] :: Task::list(erlpyt_types:tuple())
}).


