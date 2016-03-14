%% Copyright 2015-2016 Guillaume Bour
%% 
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%% http://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(standalone).
-export([main/1, main/2, on_complete/1]).

on_complete({State, Data}) ->
    io:format("letsencrypt completed: ~p (data: ~p)~n", [State, Data]),
    letsencrypt:stop().

main(Domain) ->
    main(Domain, 80).

main(Domain, Port) ->
    application:ensure_all_started(letsencrypt),

    letsencrypt:start([{mode,standalone}, staging, {cert_path, "/tmp"}, {port, Port}]),
    letsencrypt:make_cert(Domain, #{callback => fun on_complete/1}),

    ok.
