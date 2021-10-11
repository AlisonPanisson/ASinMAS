// Agent reasoner in project Argumentation_Schemes

{ include("reasoning/abr_in_aopl_with_as_v2.asl") }
{ include("as/as4rk_v2.asl") }

has_argument(Content,Justification):- argument(Content,Justification) & not(.empty(Justification)).
has_argument_against(Content,Justification):- contrary(Content,Comp) & argument(Comp,Justification) & not(.empty(Justification)).

role(Ag,Role):- has_argument(conclusion(role(Ag,Role)),J).

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+!has_argument(X) : has_argument(X,J) <- .print("I have an argument to ", X , " --> ", J).


// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
