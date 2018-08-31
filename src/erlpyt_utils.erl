%%%-------------------------------------------------------------------
%%% @author m.shikhragimov@gmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Aug 2018 16:06
%%%-------------------------------------------------------------------
-module(erlpyt_utils).
-author("m.shikhragimov@gmail.com").

%% API
-export([concat_atoms/2]).

%% @doc concatenate atoms together. Generally it uses for naming. But this is bad practice...
-spec concat_atoms(Atom1::atom(), Atom2::atom()) -> Atom3::atom().
concat_atoms(Atom1, Atom2) ->
  list_to_atom(atom_to_list(Atom1) ++ "_" ++ atom_to_list(Atom2)).
