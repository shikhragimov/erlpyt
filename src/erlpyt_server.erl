%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% This server looks at configs and adds/removes tasks by starting servers or stopping servers
%%% @end
%%% Created : 29. Aug 2018 12:15
%%%-------------------------------------------------------------------
-module(erlpyt_server).
-author("m.shikhragimov@gmail.com").
-behaviour(gen_server).
-include("erlpyt_configs.hrl").

%% API
-export([]).
-export([start_link/1]).

%% @doc Gen server callbacks
-export([init/1,
         handle_cast/2,
         handle_call/3,
         handle_info/2,
         code_change/3,
         terminate/2]).

%%====================================================================
%% API
%%====================================================================
start_link(Name) ->
     gen_server:start_link({local, Name}, ?MODULE, [], []).

%%====================================================================
%% Gen server callbacks
%%====================================================================
%% @doc initialize server with Timers for periodic task
init([]) ->
  %% check every second
  Timer = erlang:send_after(1000, self(), {check_new_tasks, sets:new()}),
  {ok, {Timer}}.

handle_cast(_, {Timer}) ->
  io:format("erlpyt_server: handle cast async~n"),
  {noreply, {Timer}}.

handle_call(_, _, {Timer}) ->
  io:format("erlpyt_server: handle call sync~n"),
  {reply, ok, {Timer}}.

%% @doc here is periodical checking of tasks changing
handle_info({check_new_tasks, OldTasksSet}, {Timer}) ->
  erlang:cancel_timer(Timer),
  %% get tasks
  TasksRec = #task{},
  {_, Tasks} = TasksRec,
%%  io:format("The tasks are: ~p~n", [Tasks]),
  TasksSet =  get_tasks_names(Tasks, []),

  NewTasksName = sets:subtract(TasksSet, OldTasksSet),
  RemovedTasksName = sets:subtract(OldTasksSet, TasksSet),

  ok = starts_new_servers(sets:to_list(NewTasksName)),
  ok = stop_old_servers(sets:to_list(RemovedTasksName)),

  NewTimer = erlang:send_after(1000, self(), {check_new_tasks, TasksSet}),
  {noreply, {NewTimer}};


handle_info(Msg, State) ->
  io:format("erlpyt_server: unknown msg: ~p~n", [Msg]),
  {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(_Reason, _State) ->
  ok.

%%====================================================================
%% Internal functions
%%====================================================================

%% @doc extract names of tasks from list of tasks
get_tasks_names([H|T], Acc) ->
  {TaskName, _} = H,
  get_tasks_names(T, [TaskName|Acc]);
get_tasks_names([], Acc) ->
  sets:from_list(Acc).

%% @doc start supervisors
starts_new_servers([TaskName|T]) ->
  %% call supervisor to start child supervisor with its task server
  erlpyt_sup:start_child_sup(erlpyt_main_supervisor, erlpyt_task_supervisor, TaskName),
  starts_new_servers(T);
starts_new_servers([]) ->
  ok.

%% @doc stop supervisors
stop_old_servers([TaskName|T]) ->
  %% call supervisor to stop child supervisor with its task server
  erlpyt_sup:stop_child_sup(erlpyt_main_supervisor, TaskName),
  stop_old_servers(T);
stop_old_servers([]) ->
  ok.

