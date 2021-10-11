// Agent sample_agent in project teste

{ include("reasoning/abr_in_aopl_with_as_v2.asl") }
{ include("performatives/performatives3_v1.asl") }
{ include("as/as4dac.asl") }

/* Initial beliefs and rules */


/* Rules */
has_argument(Content,Justification):- argument(Content,Justification) & not(.empty(Justification)).
has_argument_against(Content,Justification):- contrary(Content,Comp) & argument(Comp,Justification) & not(.empty(Justification)).

inCS(Content):- .my_name(AgentName) & agents(Agents) & .term2string(AgentsT,Agents) & .member(cs(AgentName,CS),AgentsT) & .member(Content,CS).
inCS(Content,AgentName):-  agents(Agents) & .term2string(AgentsT,Agents) & .member(cs(AgentName,CS),AgentsT) & .member(Content,CS).

isSubject(Content):- isSubject(Content)[_].
//isSubject(Content):- agents(Agents) & .term2string(AgentsT,Agents) & .nth(0,AgentsT,cs(_,CS)) & .nth(0,CS,Content).

answer_cq(cq(CqId,Content)[as(AS)],S):- has_argument(Content,Arg).
answer_cq(cq(CqId,Content)[as(AS)],S):- not(has_argument_against(Content,Arg)) & .member(Content,S).

in(AR,[AR|Rest]) :- .print(AR, " is into ").
in(AR,[_|Rest]):- .print(" Looking for ", AR). in(AR,Rest).


/* Response to new dialogue (ACCEPT or REFUSE) */	
+dialogue(X)[source(self)] <- true.
+dialogue(X)[source(Ag)]: acceptdialogue(X) <- lookupArtifact(X,A);  focus(A); performatives.send(Ag,acceptdialogue,X).  
+dialogue(X)[source(Ag)]: not acceptdialogue(X) <- focus(X); performatives.send(Ag,refusedialogue,X). 


+!continueDialogue(Dialogue):  subject(Subject,Dialogue) & argument(Subject,Arg)
	<- //!send(Dialogue,question,Subject[dialogue(Dialogue)]).
		.print("Aqui -- ");
		+isSubject(Subject)[dialogue(Dialogue)];
		!send(Dialogue,question,Subject[dialogue(Dialogue)]).

+!continueDialogue(Dialogue).


/* Response to an ASSERT */		

+!responseAssert(Sender,Content[dialogue(Dialogue),source(Source)]): isSubject(Content)
	<-	!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]).
	
+!responseAssert(Sender,Content[dialogue(Dialogue),source(Source)])
	<-	!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]).

+!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument(Content,Arg) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument_against(Content,Arg) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	performatives.send(Sender,question,Content[dialogue(Dialogue)]).
	
+!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]): .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
				
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument(Content,Arg) & .print("Received content:  ASSERT(",Content,")")
	<-	.print("## I have an argument for it: ", Arg);
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument_against(Content,Arg) & contrary(C,Comp) & not(inCS(Comp)) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	performatives.send(Sender,question,Content[dialogue(Dialogue)]).
		
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument_against(Content,Arg) & contrary(C,Comp) & inCS(Comp) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")").
	
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]):  .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	performatives.send(Sender,accept,Content[dialogue(Dialogue)]);
		!check_subject(Sender,Dialogue).
		
	

/* Response to a JUSTIFY */

/* correct role */
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): isSubject(access(Name,Info)) & contrary(access(Name,Info),C) & role(Name,Role) & .member(satisfies(Name,role(Role)),Premises) 
																				& .member(~access_rule(CA,CI),Premises) & emrg_rule(Emrg,access_rule(CA,CI)) & Emrg 
																				& .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, "," , [defeasible_rule(C,S)[as(AS)],Premises],")")
	<- 	!send(Sender,assert,Emrg[dialogue(Dialogue)]).
		//.print("Subject: ", access(Name,Info), " Received: ", defeasible_rule(C,S)[as(AS)], Premises).

/* wrong role */
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): isSubject(access(Name,Info)) & contrary(access(Name,Info),C) & role(Name,Role) & not(.member(satisfies(Name,role(Role)),Premises))
								& .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, "," , [defeasible_rule(C,S)[as(AS)],Premises],")")
	<- 	!send(Sender,assert,role(Name,Role)[dialogue(Dialogue)]).
		//.print("Subject: ", access(Name,Info), " Received: ", defeasible_rule(C,S)[as(AS)], Premises).


/* wrong role */
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): isSubject(C) 
			& .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, "," , [defeasible_rule(C,S)[as(AS)],Premises],")")
	<- //.print("Subject: ", access(Name,Info), " Received: ", defeasible_rule(C,S)[as(AS)], Premises);
		.print("Dialogue ends!").

		
/* Response to a QUESTION */		

+!respondQuestion(Sender,Content,D): has_argument(Content,Justification) & .my_name(MyName) & .print("Received Message: QUESTION(",Sender, ",", MyName, "," , Content, ")")
<- 	    allAgents(Ag)[artifact_id(A)];
		.term2string(AgT,Ag);
		+isSubject(Content)[dialogue(D)];
	    performatives.send(AgT,accept,Content[dialogue(Dialogue)]).

+!respondQuestion(Sender,Content,D): has_argument_against(Content,Justification) & .my_name(MyName) & .print("Received Message: QUESTION(",Sender, ",", MyName, "," , Content, ")")
<- 	    allAgents(Ag)[artifact_id(A)];
		.term2string(AgT,Ag);
		+isSubject(Content)[dialogue(D)];
	    performatives.send(AgT,justify,justify(Justification,D)).

+!respondQuestion(Sender,Content,D) <- .my_name(MyName); .print("Received Message: QUESTION(",Sender, ",", MyName, "," , Content, ")").


/* ACCEPT */
+!receiveAccept(Sender,Content[dialogue(Dialogue),source(Source)]): subject(Content,Dialogue) & .my_name(MyName) & .print("Received Message: ACCEPT(",Sender, ",", MyName, "," , Content, ")")
	<- !closedialogue(Dialogue).
	
+!receiveAccept(Sender,Content[dialogue(Dialogue),source(Source)]): not(subject(Content,Dialogue)) & .my_name(MyName) & .print("Received Message: ACCEPT(",Sender, ",", MyName, "," , Content, ")").


/* Check Subject */
+!check_subject(Sender,Dialogue): isSubject(Content) & has_argument(Content,Arg)
	<- 	performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!check_subject(Sender,Dialogue): isSubject(Content) & consideringCS(Sender)[dialogue(Dialogue)] & has_argument_against(Content,Arg)
	<- 	-consideringCS(Sender)[dialogue(Dialogue)];
		performatives.send(Sender,justify,justify(Arg,Dialogue)).

+!check_subject(Sender,Dialogue): agents(Agents) & isSubject(Content) & .term2string(AgentsT,Agents) & .nth(0,AgentsT,cs(_,CS))
	<- 	!add_bb(CS);
		+consideringCS(Sender)[dialogue(Dialogue)];
		!check_subject(Sender,Dialogue).
	
+!check_subject(Sender,Dialogue)
	<- performatives.send(Sender,refuse,Content[dialogue(Dialogue)]).
	
+!add_bb([F|R])	<- +F; !add_bb(R).
+!add_bb([F])	<- +F.
+!add_bb([]).

+role(S,R): role(S,Temp) & Temp\==R
 	<- 	-role(S,Temp);
 		+role(S,R).
	