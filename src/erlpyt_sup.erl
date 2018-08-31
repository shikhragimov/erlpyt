%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%% @doc erlpyt top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(erlpyt_sup).
-author("m.shikhragimov@gmail.com").
-behaviour(supervisor).

%% API
-export([
  start_link/1,
  start_server/3,
  start_child_sup/3,
  stop_child_sup/2
  ]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
%% @doc start main supervisor
start_link(ServiceSupName) ->
    supervisor:start_link({local, ServiceSupName}, ?MODULE, []).

%% @doc start main server
start_server(ServiceSupName, ServiceModule, ServiceName) ->
    ChildSpec = {ServiceName,
                 {ServiceModule, start_link, [ServiceName]},
                  permanent, 10500, worker, [ServiceModule]},
    supervisor:start_child(ServiceSupName, ChildSpec).

%% @doc star supervisor for task server. Lately it starts task server itself
start_child_sup(ServiceSupName, ServiceModule, TaskName) ->
  ChildSpec = {erlpyt_utils:concat_atoms(TaskName, sup),
               {ServiceModule, start_link, [
                 erlpyt_utils:concat_atoms(TaskName, sup),
                 erlpyt_task_server,
                 erlpyt_utils:concat_atoms(TaskName, server),
                 TaskName]},
    permanent, 10500, supervisor, [ServiceModule]},
  supervisor:start_child(ServiceSupName, ChildSpec).

%% @doc stop and delete supervisor of task server
stop_child_sup(ServiceSupName, TaskName) ->
  supervisor:terminate_child(ServiceSupName,erlpyt_utils:concat_atoms(TaskName, sup)),
  supervisor:delete_child(ServiceSupName,erlpyt_utils:concat_atoms(TaskName, sup)).


%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->
    {ok, {{one_for_one, 6, 3600}, []}}.
