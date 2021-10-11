/* Rules */

/* AS-Based Reasoning */

answer([cq(Cq_name,Pred)[as(AS),_]]):-  (strict_inference(Pred) | defeasible_inference(Pred)). // & .print("Critical Question ", Pred, " answered!"). 
answer([cq(Cq_name,Pred)[as(AS),_]|T]):- (strict_inference(Pred) | defeasible_inference(Pred)) //& .print("Critical Question ", Pred, " answered!") 
& answer(T). 
answer([]).

/* strict_inference*/

strict_inference(Result,Arg,{Goal}) :-  not .list(Goal) & Goal & .concat(Arg,[],Result).
strict_inference(Result,Arg,Goal) :-  not .list(Goal) & Goal[All] & .concat(Arg,[Goal[All]],Result).
strict_inference(Result,Arg,Goal) :-  not .list(Goal) & Goal[All] & .concat(Arg,[Goal[All]],Result). // necessary for predicates derived from (Jason's Prolog-like) inference rules
strict_inference(Result,Arg,[Goal]):-  strict_inference(Result,Arg,Goal).
strict_inference(Result,Arg,[First|Rest]):-  .length(Rest,X) & X>0 & strict_inference(Result1,Arg,First) & strict_inference(Result2,[],Rest) & concat(Result1,Result2,Result).


/* defeasible_inference */

defeasible_inference(Result,Arg,true):- Result=Arg.
defeasible_inference(Result,Arg,{Goal}) :- Goal & .concat(Arg,[],Result).

defeasible_inference(Result,Arg,[Goal]):- defeasible_inference(Result,Arg,Goal).

defeasible_inference(Result,Arg,[First|Rest]) :- 
		defeasible_inference(Result1,Arg,First) 
		& defeasible_inference(Result2,[],Rest) 
		& concat(Result1,Result2,Result). // A conjunction is defeasibly derivable if and only if both conjuncts are defeasibly derivable.
		
defeasible_inference(Result,Arg,Goal) :- not .list(Goal) & strict_inference(Result,Arg,Goal) . // A goal is defeasibly derivable if it is strictly derivable.

defeasible_inference(Result,Arg,Goal) :- 
		not .list(Goal) 
		& def_rule(defeasible_rule(Goal,Condition)[as(AS)]) & concat(Arg,[defeasible_rule(Goal,Condition)[as(AS)]],X)
		& defeasible_inference(Result,X,Condition)
		& not(rebutted(defeasible_rule(Goal,Condition))) 
		& not(undercut(defeasible_rule(Goal,Condition)))
		& jia.get_unifier(defeasible_rule(Goal,Condition)[as(AS)],Unifier) //& .print("Unifier: ", Unifier) // get the unifier
		& jia.get_cqs(AS,Unifier,Cqs)// & .print("CQs:", Cqs) // get the critical questions instantiated accordign unifier
		& .term2string(CqsS,Cqs) // & .print("CQs terms:", CqsS) 
		& answer(CqsS). // answer all them
		
defeasible_inference(Result,Arg,Goal) :- 
		not .list(Goal) & def_rule(defeasible_rule(Goal,Condition)[as(AS)]) & concat(Arg,[defeasible_rule(Goal,Condition)[as(AS)]],X) // & .print(Condition)
		& not(contrary(Goal,Contrary1) & strict_inference(Contrary1)) // If defeater preemption is enabled, then  a goal is defeasibly derivable if it is 
		& defeasible_inference(Result,X,Condition) 
		& not(contrary(Goal,Contrary2) 
			& strict_rule(Contrary2,Condition2) & Condition2 \== true 
			& defeasible_inference(Condition2)) // the head of a defeasible rule whose condition is defeasibly derivable, provided every
		& not(contrary(Goal,Contrary3) 
			& def_rule(defeasible_rule(Contrary3,Condition3)) 
			& defeasible_inference(Condition3) 
			& not(preempted(defeasible_rule(Contrary3,Condition3)))) //rebutting or undercutting defeater for that rule is itself rebutted by a strict rule or
		& not(contrary(Goal,Contrary4) 
			& undercut_rule(Contrary4,Condition4) 
			& defeasible_inference(Condition4) & not(preempted(undercut_rule(Contrary4,Condition4)))) //a superior defeasible rule.
		& jia.get_unifier(defeasible_rule(Goal,Condition)[as(AS)],Unifier) //& .print("Unifier: ", Unifier) // get the unifier
		& jia.get_cqs(AS,Unifier,Cqs) //& .print(Cqs)// get the critical questions instantiated accordign unifier
		& .term2string(CqsS,Cqs) //& .print(Cqs)
		& answer(CqsS). // answer all them
			
			
/* ################################################################################################################################################# */			
			
/* Without concatenate to check attacks */

strict_inference({Goal}) :- not .list(Goal) & Goal.
strict_inference(Goal) :- not .list(Goal) & Goal.
strict_inference([Goal]):- strict_inference(Goal).
strict_inference([First|Rest]):- .length(Rest,X) & X>0 & strict_inference(First) & strict_inference(Rest).
strict_inference(Goal) :- not .list(Goal) & strict_rule(Goal,Condition) & strict_inference(Condition).


/* defeasible_inference */


defeasible_inference({Goal}) :- Goal.

defeasible_inference([Goal]):-  defeasible_inference(Goal).

defeasible_inference([First|Rest]) :-  defeasible_inference(First) & defeasible_inference(Rest). // A conjunction is defeasibly derivable if and only if both conjuncts are defeasibly derivable.
		
defeasible_inference(Goal) :- not .list(Goal) & strict_inference(Goal). // A goal is defeasibly derivable if it is strictly derivable.

defeasible_inference(Goal) :- 
		not .list(Goal) & strict_rule(Goal,Condition)
		& defeasible_inference(Condition) 
		& not(rebutted(strict_rule(Goal,Condition))). // A goal is defeasibly derivable if it is the head of an ordinary Prolog rule whose condition is defeasibly derivable and which is not rebutted.
		
defeasible_inference(Goal) :- 
		not .list(Goal) & def_rule(defeasible_rule(Goal,Condition)[as(AS)])
		& defeasible_inference(Condition) 
		& not(rebutted(defeasible_rule(Goal,Condition))) 
		& not(undercut(defeasible_rule(Goal,Condition)))
		& jia.get_unifier(defeasible_rule(Goal,Condition)[as(AS)],Unifier) //& .print("Unifier: ", Unifier) // get the unifier
		& jia.get_cqs(AS,Unifier,Cqs) //& .print(Cqs)// get the critical questions instantiated accordign unifier
		& .term2string(CqsS,Cqs) //& .print(Cqs)
		& answer(CqsS). // answer all them
		
defeasible_inference(Goal) :- 
		not .list(Goal) & def_rule(defeasible_rule(Goal,Condition)[as(AS)])
		& not(contrary(Goal,Contrary1) & strict_inference(Contrary1)) // If defeater preemption is enabled, then  a goal is defeasibly derivable if it is 
		& defeasible_inference(Condition) 
		& not(contrary(Goal,Contrary2) 
			& strict_rule(Contrary2,Condition2) & Condition2 \== true 
			& defeasible_inference(Condition2)) // the head of a defeasible rule whose condition is defeasibly derivable, provided every
		& not(contrary(Goal,Contrary3) 
			& def_rule(defeasible_rule(Contrary3,Condition3)) 
			& defeasible_inference(Condition3) 
			& not(preempted(defeasible_rule(Contrary3,Condition3)))) //rebutting or undercutting defeater for that rule is itself rebutted by a strict rule or
		& not(contrary(Goal,Contrary4) 
			& undercut_rule(Contrary4,Condition4) 
			& defeasible_inference(Condition4) & not(preempted(undercut_rule(Contrary4,Condition4))))
		& jia.get_unifier(defeasible_rule(Goal,Condition)[as(AS)],Unifier) //& .print("Unifier: ", Unifier) // get the unifier
		& jia.get_cqs(AS,Unifier,Cqs) //& .print(Cqs)// get the critical questions instantiated accordign unifier
		& .term2string(CqsS,Cqs) //& .print(Cqs)
		& answer(CqsS). // answer all them
			
/* ################################################################################################################################################# */					
			


/* derived_from(+Clause1,+Clause2) */ // REVER ESSA PARTE

derived_from(Clause1,Clause2):- strict_rule(Clause1,Clause2). 
derived_from(Clause1,Clause2):- strict_rule(Clause1,Rest) & derived_from(Rest,Clause2).    
derived_from(Clause1,Clause2):- defeasible_rule(Clause1,Clause2).
derived_from(Clause1,Clause2):- defeasible_rule(Clause1,Rest) & derived_from(Rest,Clause2).
derived_from([First],Clause2):- derived_from(First, Clause2).

/* complement(+Clause1,-Clause2) Succeeds if Clause1 is neg Clause2 or if Clause2 is is neg Clause1. */ 

complement(Atom1,Atom2):- not .list(Atom1) & .term2string(Atom1,String) & .substring("~",String) & .delete("~",String,Temp) & .term2string(Atom2,Temp). 
complement(Atom1,Atom2):- not .list(Atom1) & .term2string(Atom1,String) & not .substring("~",String) & .concat("~",Atom1,Y) & .term2string(Atom2,Y).  

/* contrary(+Clause1,-Clause2) Discovers Clause2 which either is the complement of Clause1 or is incompatible with Clause1. */ //OK

contrary(Clause1,Clause2) :- incompatible(Clause1,Clause2).
contrary(Clause1,Clause2) :- incompatible(Clause2,Clause1).
contrary(Clause1,Clause2) :- complement(Clause1,Clause2).

/* sup_relation(+Rule1,+Rule2) Succeeds if the body of Rule2 is defeasibly derivable from the body of Rule1, but the body of Rule1 is not defeasibly derivable from the body of Rule2. The user can also force superiority by adding clauses for the predicate "sup". */ //OK

sup_relation(Rule1,Rule2) :- sup(Rule1,Rule2).
sup_relation(defeasible_rule(_,Body1),defeasible_rule(_,Body2)) :- derived_from(Body2,Body1) & not(derived_from(Body1,Body2)).
sup_relation(defeasible_rule(_,Body1),undercut_rule(_,Body2)) :- derived_from(Body2,Body1) & not(derived_from(Body1,Body2)).

/* undercut(+Rule) Succeeds if the Rule is defeated in the knowledge base KB by an undercutting defeater.*/ //OK

undercut(defeasible_rule(Head,Body)) :- contrary(Head,Contrary) & undercut_rule(Contrary,Condition) & defeasible_inference(Condition) & not(sup_relation(defeasible_rule(Head,Body),undercut_rule(Contrary,Body))).// Only defeasible rules may be undercut by pure defeaters.

/* rebutted(+Rule) Succeeds if the Rule is defeated in the knowledge base KB by a rebutting defeater (an ordinary Prolog rule or a defeasible rule to which the Rule is not superior). */ //OK

rebutted(defeasible_rule(Head,Body)) :-  contrary(Head,Contrary) & strict_inference(Contrary). //Any rule is rebutted if a contrary of its head is strictly derivable.
rebutted(defeasible_rule(Head,Body)) :-  contrary(Head,Contrary) & strict_rule(Contrary,Body) & Body \== true & defeasible_inference(Body). // Any rule may be rebutted by an ordinary Prolog rule with a contrary head.
rebutted(defeasible_rule(Head,Body)) :-  contrary(Head,Contrary) & def_rule(defeasible_rule(Contrary,Condition)[as(AS)]) 
& defeasible_inference(Condition) & not(sup_relation(defeasible_rule(Head,Body),defeasible_rule(Contrary,Condition)))
& jia.get_unifier(defeasible_rule(Goal,Condition)[as(AS)],Unifier) //& .print("Unifier: ", Unifier) // get the unifier
& jia.get_cqs(AS,Unifier,Cqs) //& .print(Cqs)// get the critical questions instantiated accordign unifier
& .term2string(CqsS,Cqs) //& .print(Cqs)
& answer(CqsS). // answer all them


/*  preempted(++Rule) Succeeds if the Rule is defeated in the knowledge base KB by a superior rebutting defeater (an ordinary Prolog rule or a defeasible rule which is superior to the Rule.) */ //OK
        
preempted(Rule) :- Rule =.. [_,Head,_] & .nth(0,Head,X) &  contrary(X,Contrary) & strict_inference(Contrary). // Any rule is preempted if a contrary of its head is strictly derivable.
preempted(Rule) :- Rule =.. [_,Head,_] & .nth(0,Head,X) &  contrary(X,Contrary) & strict_rule(Contrary,Body) & Body \== true & defeasible_inference(Body). //Any rule may be preempted by an ordinary Prolog rule with a contrary head.
preempted(defeasible_rule(Head,Body)) :- contrary(Head,Contrary) & def_rule(defeasible_rule(Contrary,Condition)) & defeasible_inference(Condition) & sup_relation(defeasible_rule(Contrary,Condition),defeasible_rule(Head,Body)). //Defeasible rules may be preempted by superior defeasible rules with contrary heads.

/* def_rule(++Rule) Succeeds if KB is the entire d-Prolog knowledge base and Rule is any defeasible rule in KB, or if Rule is a defeasible rule in the d-Prolog knowledge base and the body of Rule is not the atom 'true'. */

def_rule(defeasible_rule(Head,Body)[as(AS)]) :- defeasible_rule(Head,Body)[as(AS)].
def_rule(defeasible_rule(Head,Body)[as(AS)]) :- defeasible_rule(Head,Body)[as(AS)] & Body \== true.

/* concat*/

concat([ ], L, L).
concat([H|T], L, [H|M]) :- concat(T, L, M).

/* Derivation */

argument(Content, Arg):- strict_inference(Arg,[],Content) | defeasible_inference(Arg,[],Content).
argument(Content, Arg):- false.

/* pattern */

// USE - strict_rule 		- for Strict Rule
// USE - defeasible_rule 	- for Defeasible Rule
// USE - undercut_rule 		- for Undercut Rule (Defeater)
// USE - sup(Rule1,Rule2)   - for superiority between rules
// USE - complement(Atom1,Atom2)  - for complement of an atom.
// USE - incompatible(Atom1,Atom2)  - for incompatible atoms.



