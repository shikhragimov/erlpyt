%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% The only function of this server is to manage periodic tasks.
%%% @end
%%% Created : 30. Aug 2018 15:25
%%%-------------------------------------------------------------------
-module(erlpyt_task_server).
-author("m.shikhragimov@gmail.com").

%% API
-export([]).
-author("m.shikhragimov@gmail.com").
-behaviour(gen_server).
-include("erlpyt_configs.hrl").

%% API
-export([]).
-export([start_link/2]).

%% Gen server callbacks
-export([init/1,
         handle_cast/2,
         handle_call/3,
         handle_info/2,
         code_change/3,
         terminate/2]).

%%====================================================================
%% API
%%====================================================================
start_link(Name, TaskName) ->
  gen_server:start_link({local, Name}, ?MODULE, [TaskName], [TaskName]).

%%====================================================================
%% Gen server callbacks
%%====================================================================


%% @doc initialize server with Timer for periodic task
init([TaskName]) ->
  %%  start first task (only first) after 1 second
  io:format("erlpyt_task_server: starting preiodic tasks~n"),
  TasksRec = #task{},
  {Period, M, F, A} = proplists:get_value(TaskName, TasksRec#task.tasks),
  StartTime = erlang:monotonic_time(millisecond),
  self() ! {start_tasks, TaskName, [M, F, A]},
  ok = start_tasks(M, F, A),
  {ok, {StartTime, Period}}.

%% @doc not used now
handle_cast({parse, []}, {Timer}) ->
  io:format("erlpyt_task_server: handle cast async~n"),
  {noreply, {Timer}}.

%% @doc not used now
handle_call({create, []}, _, {Timer}) ->
  io:format("erlpyt_task_server: handle call sync~n"),
  {reply, ok, {Timer}}.

%% @doc here we catch messages to start periodical tasks
handle_info({start_tasks, TaskName, [OldM, OldF, OldA]}, {OldStartTime, OldPeriod}) ->
  TasksRec = #task{},
  {NewPeriod, M, F, A} = proplists:get_value(TaskName, TasksRec#task.tasks),

  NewStartTime = get_timer(NewPeriod, OldPeriod, OldStartTime),
  NextCall = NewPeriod - (erlang:monotonic_time(millisecond)-NewStartTime) rem NewPeriod,
  erlang:display(NextCall),
  erlang:display(NextCall),
  _NewTimer = erlang:send_after(NextCall, self(), {start_tasks, TaskName, [M, F, A]}),

  io:format("erlpyt_task_server: start periodical tasks for {~p} ~n", [TaskName]),
  ok = start_tasks(OldM, OldF, OldA),
  io:format("erlpyt_task_server: task restarting for {~p} done~n", [TaskName]),
  {noreply, {NewStartTime, NewPeriod}};


%% @doc handle unknown message
handle_info(Msg, State) ->
  io:format("erlpyt_task_server: unknown msg: ~p~n", [Msg]),
  {noreply, State}.

%% @doc as a template by now
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% @doc as a template by now
terminate(_Reason, _State) ->
  ok.

%%====================================================================
%% Internal functions
%%====================================================================
%% @doc function which spawns parallel tasks
start_tasks(M, F, [H|T]) ->
  {ok, P} = python:start([{python, "python3"}]),
  G =
    fun(X) ->
      timer:sleep(2000),
      try
        python:call(P, M, F, [X])
        catch error:{python, Class, Argument, _} ->
%%          io:format(" ~p~n", [StackTrace]),
          io:format(" ~p~n",[Argument]),
          io:format(" ~p~n", [Class]),
          error
      end,
    python:stop(P)
    end,
  [spawn(fun() -> G(X) end) || X <- [H]],
  start_tasks(M, F, T);
start_tasks(_, _, []) ->
  ok.


%% @doc function to get new StartTime if Period of tasks was changed
get_timer(Period, Period, OldStartTime) ->
  OldStartTime;
get_timer(_OldPeriod, _NewPeriod, _) ->
  erlang:monotonic_time(millisecond).
