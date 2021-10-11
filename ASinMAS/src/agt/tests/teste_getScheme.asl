// Agent teste_getScheme in project Argumentation_Schemes

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("as/as4rk.asl") }
//{ include("as/as4dac.asl") }


/* Initial beliefs and rules */

/* Initial goals */

//!getScheme(as4rk).

/* Plans */

+!add_scheme(SchemeS): .term2string(SchemeT,SchemeS) <- .print(SchemeS); .print(SchemeT); !learn_as(SchemeT).
+!add_scheme(SchemeT) <- .print(SchemeT); !learn_as(SchemeT).

+!getScheme(AS) : jia.get_scheme3(AS,SchemeS) & .term2string(SchemeT,SchemeS) <- .print(SchemeS); .print(SchemeT); !learn_as(SchemeT).
//+!getScheme(AS) : jia.get_scheme3(AS,SchemeS) <- .print(SchemeS).//; !learn_as(SchemeT).


+!learn_as([Scheme, CQ1, CQ2, CQ3, CQ4]) 
	<-  .print(Scheme); 
		.concat("{", Scheme, ":- true}", SchemeRes);
		.term2string(SchemeTerm, SchemeRes);
		.print("aqui: ",SchemeTerm);
		+SchemeTerm;
		.print(CQ1);
		.concat("{", CQ1, ":- true}", CQ1Res);
		.term2string(CQ1Term, CQ1Res);
		.print("aqui: ",CQ1Term);
		+CQ1Term;
		.print(CQ2);
		.concat("{", CQ2, ":- true}", CQ2Res);
		.term2string(CQ2Term, CQ2Res);
		.print("aqui: ",CQ2Term);
		+CQ2Term;
		.print(CQ3);
		.concat("{", CQ3, ":- true}", CQ3Res);
		.term2string(CQ3Term, CQ3Res);
		.print("aqui: ",CQ3Term);
		+CQ3Term;
		.print(CQ4);
		.concat("{", CQ4, ":- true}", CQ4Res);
		.term2string(CQ4Term, CQ4Res);
		.print("aqui: ",CQ4Term);
		+CQ4Term.

+!learn_as([Scheme, CQ1, CQ2, CQ3, CQ4]) 
	<-  .print(Scheme); 
		+Scheme;
		.print(CQ1);
		//+{CQ1:-true};
		+CQ1;
		.print(CQ2);
		+CQ2;
		.print(CQ3);
		+CQ3;
		.print(CQ4);
		+CQ4.

+!printScheme(Scheme,Cqs) <- .print(Scheme); +Scheme; !printCqs(Cqs).
+!printCqs([H|T]) <- .print(H); +H; !printCqs(T).
+!printCqs([H]) <- .print(H); +H;.
+!printCqs([]).

+as(Scheme,[CQ1, CQ2, CQ3, CQ4]) 
	<-  .print(Scheme); 
		+Scheme; 
		.print(CQ1);
		+CQ1;
		.print(CQ2);
		+CQ2;
		.print(CQ3);
		+CQ3;
		.print(CQ4);
		+CQ4.
		