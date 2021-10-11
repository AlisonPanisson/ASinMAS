// Agent as4dac in project data_access_control

/* THIS FILE IMPLEMENTS THE ARGUMENTATION SCHEME FOR DATA ACCESS CONTROL [Panisson et al. 2018]*/

/* Sub-category */ //TO check this part
//subc(X,Y) :- subc(X,Y).
//subc(X,Y) :- subc(X,Z) & subc(Z,Y).

~subc(Inf,Sup) :- not(subc(Inf,Sup)).

access_rule(R,C):- emrg_rule(Emrg,access_rule(R,C)) & Emrg.

satisfies(A,role(R)):- role(A,R).

is_one(S1,S1):- true.
is_one(S1,[S1|_]):- true.
is_one(S1,[H|T]):- is_one(S1,T).


/* Presuptions - According DAC Models */
~access_rule(AC,IC) :- not(access_rule(AC,IC)).

/* AS4DAC - Argumentation scheme for Data Access Control */
defeasible_rule(access(A,I),[inf_category(I,C),ac_category(A,R),access_rule(R,C)])[as(as4dac)].
	cq(cq1,inf_category(I,C))[as(as4dac)].
	cq(cq2,ac_category(A,R))[as(as4dac)].
	cq(cq3,access_rule(R,C))[as(as4dac)].
	cq(cq4,(not(inf_category(I,C2) & ~subc(C,C2) & ~access_rule(R,C2))))[as(as4dac)]. 
	cq(cq5,(not(ac_category(A,R2) & ~subc(R,R2) & ~access_rule(R2,C))))[as(as4dac)].
	cq(cq6,(not(emrg_rule(S,access_rule(R,C)) & ~emrg(S))))[as(as4dac)].


/* AS4ACA - Argumentation scheme for Access-Category Assignment */	  				
defeasible_rule(ac_category(A,R),[constr(S,R),satisfies(A,S)])[as(as4aca)].
	cq(cq1,(is_one(S1,S) & constr(S,R) & satisfies(A,S1)))[as(as4aca)].
	cq(cq2,(not(subc(R2,R) & constr(S2,R) & satisfies(A,S2))))[as(as4aca)].
	

/* Counter-Example */
defeasible_rule(~access(A,I),[inf_category(I,C),ac_category(A,R),~access_rule(R,C)])[as(comp_as4dac)].