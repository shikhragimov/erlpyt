%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% erlpyt supervisor for every task
%%% @end
%%% Created : 30. Aug 2018 16:14
%%%-------------------------------------------------------------------
-module(erlpyt_task_supervisor).
-author("m.shikhragimov@gmail.com").
-behaviour(supervisor).
%% API
-export([start_link/4]).

-export([init/1]).


-define(SERVER, ?MODULE).


%%====================================================================
%% API functions
%%====================================================================

start_link(ServiceSupName, ServiceModule, ServiceName, Arguments) ->
  io:format("erlpyt_task_supervisor: Starting task supervisor~n"),
  supervisor:start_link({local, ServiceSupName}, ?MODULE, [ServiceModule, ServiceName, Arguments]).


%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([ServiceModule, ServiceName, Arguments]) ->
    MaxRestart = 5,
    MaxTime = 100,
    {ok, {{one_for_one, MaxRestart, MaxTime},
     [{ServiceName,
       {erlpyt_task_server, start_link, [ServiceName, Arguments]},
        transient,
        60000,
        worker,
        [ServiceModule]}]}}.
%%====================================================================
%% Internal functions
%%====================================================================
