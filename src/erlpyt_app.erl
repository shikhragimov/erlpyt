%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc erlpyt public API
%%%
%%% @end
%%%-------------------------------------------------------------------

-module(erlpyt_app).
-author("m.shikhragimov@gmail.com").

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================
%% @doc starts supervisor, then server
start(_StartType, _StartArgs) ->
  sync:go(),
  % start main supervisor
  {ok, _} = erlpyt_sup:start_link(erlpyt_main_supervisor),
  % start server
  {ok, _} = erlpyt_sup:start_server(
    erlpyt_main_supervisor,
    erlpyt_server,
    erlpyt_main_server).
%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================


