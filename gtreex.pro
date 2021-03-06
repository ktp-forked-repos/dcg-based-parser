convchars(R,SI,SO) :- 
   SI='', R=SO, !;
   (
      number(SI), number_chars(SI,SIC), atom_chars(SIA,SIC), !;
      SIA=SI
   ),
   sub_atom(SIA,0,1,_,N), sub_atom(SIA,1,_,0,SI1),
      (
         N='"', N1='\\"', !;
%         =(N,\), write('*'), =(N1,\\), !;
         N='\n', N1='\\\\n', !;
         N='\b', N1='\\\\b', !;
         N='\r', N1='\\\\r', !;
         N='\f', N1='\\\\f', !;
         N='\t', N1='\\\\t', !;
         N1=N
      ),
      atom_concat(SO,N1,SO1), convchars(R,SI1,SO1).

parse_functor(P,T,C) :-
   functor(T,N,L),
   number_chars(C,TL), atom_chars(N4,TL), atom_concat(P,'x',Q), atom_concat(Q,N4,N1),
   write(N1), write(' [label="'),
   (N='em',
       !;
       convchars(N2,N,''), write(N2)),
   (L > 0,
       write('"];\n'), parse_arg(N1,T,L,1), !;
       write('",shape="plaintext"];\n')),
   (P='',
       !;
       write(P), write(' -> '), write(N1), write(';\n')).

parse_arg(P,T,L,C) :- arg(C,T,X),
   parse_functor(P,X,C), C1 is C + 1, C < L,
   parse_arg(P,T,L,C1), !;
   true.

gtree(S) :-
   open('data.dot',write,Z), set_output(Z),
   write('digraph Parse {\nnode [shape="box"];\n'),
   parse_functor('',S,1),
   write('}\n'), close(Z), set_output(user_output),
   write('Graph data saved\n').

