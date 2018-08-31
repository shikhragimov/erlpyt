%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Aug 2018 12:18
%%%-------------------------------------------------------------------
-module(erlpyt_types).
-author("m.shikhragimov@gmail.com").

%% API
%% API
-export_type([
  task/0
  ]).


%% @doc type of task
-type task() :: {
  integer(),  % period of task repeating
  atom(), % task python module
  atom(), % task python function
  list()
}.
