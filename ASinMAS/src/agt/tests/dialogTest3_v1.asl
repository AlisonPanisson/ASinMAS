// Agent sample_agent in project teste

{ include("reasoning/abr_in_aopl_with_as_v2.asl") }
{ include("performatives/performatives3_v1.asl") }
{ include("as/as4rk.asl") }

/* Initial beliefs and rules */


/* Rules */
has_argument(Content,Justification):- argument(Content,Justification) & not(.empty(Justification)).
has_argument_against(Content,Justification):- contrary(Content,Comp) & argument(Comp,Justification) & not(.empty(Justification)).

inCS(Content):- .my_name(AgentName) & agents(Agents) & .term2string(AgentsT,Agents) & .member(cs(AgentName,CS),AgentsT) & .member(Content,CS).
inCS(Content,AgentName):-  agents(Agents) & .term2string(AgentsT,Agents) & .member(cs(AgentName,CS),AgentsT) & .member(Content,CS).

isSubject(Content):- agents(Agents) & .term2string(AgentsT,Agents) & .nth(0,AgentsT,cs(_,CS)) & .nth(0,CS,Content).

answer_cq(cq(CqId,Content)[as(AS)],S):- has_argument(Content,Arg).
answer_cq(cq(CqId,Content)[as(AS)],S):- not(has_argument_against(Content,Arg)) & .member(Content,S).


/* Response to new dialogue (ACCEPT or REFUSE) */	
+dialogue(X)[source(self)] <- true.
+dialogue(X)[source(Ag)]: acceptdialogue(X) <- lookupArtifact(X,A);  focus(A); performatives.send(Ag,acceptdialogue,X).  
+dialogue(X)[source(Ag)]: not acceptdialogue(X) <- focus(X); performatives.send(Ag,refusedialogue,X). 

+!continueDialogue(Dialogue): subject(Subject,Dialogue) & argument(Subject,Arg)
	<- !send(Dialogue,assert,Subject[dialogue(Dialogue)]).

+!continueDialogue(Dialogue).


/* Response to an ASSERT */		

+!responseAssert(Sender,Content[dialogue(Dialogue),source(Source)]): isSubject(Content)
	<-	!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]).
	
+!responseAssert(Sender,Content[dialogue(Dialogue),source(Source)])
	<-	!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]).

+!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument(Content,Arg) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	//.print("I have an argument for it: ", Arg);
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument_against(Content,Arg) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	//.print("I have an argument against it: ", Arg);
		performatives.send(Sender,question,Content[dialogue(Dialogue)]).
	
+!responseAssertSubject(Sender,Content[dialogue(Dialogue),source(Source)]): .my_name(MyName) &.print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	//.print("I have no argument for or against it: ");
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
				
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument(Content,Arg) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	//.print("## I have an argument for it: ", Arg);
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument_against(Content,Arg) & contrary(C,Comp) & not(inCS(Comp)) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")")
	<-	//.print("## I have an argument against it: ", Arg);
		performatives.send(Sender,question,Content[dialogue(Dialogue)]).
		
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): has_argument_against(Content,Arg) & contrary(C,Comp) & inCS(Comp) & .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", MyName, "," , Content,")").
	//<-	.print("## I don't have another argument against it: ", Arg).
	
+!responseAssertContent(Sender,Content[dialogue(Dialogue),source(Source)]): .my_name(MyName) & .print("Received Message:  ASSERT(",Sender, ",", Content,")")
	<-	//.print("## I have no argument for or against it: ");
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]);
		!check_subject(Sender,Dialogue).
		
	

/* Response to a JUSTIFY */
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): has_argument(C,Arg) & .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, ","  ,[defeasible_rule(C,S)[as(AS)],Premises],")")
	<- //.print("I have an argument for it: ", C, Dialogue);
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): has_argument_against(C,Arg) & contrary(C,Comp) & not(inCS(Comp)) & .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, ","  ,[defeasible_rule(C,S)[as(AS)],Premises],")")
	<- //.print("I have an argument against it: ", C, " -- i.e., ", Comp);
	   	!send(Sender,assert,Comp[dialogue(Dialogue)]).
	   	
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): has_argument_against(C,Arg) & contrary(C,Comp) & inCS(Comp) & .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, ","  ,[defeasible_rule(C,S)[as(AS)],Premises],")")
	<- 	//.print("## I don't have another arguments against it, let's check the critical questions:'")
		jia.get_unifier(defeasible_rule(C,S)[as(AS)],Unifier);
		jia.get_cqs(AS,Unifier,Cqs);
		.term2string(CqsS,Cqs);
		+list_cqs2discuss([]);
		for(.member(cq(CqID,Temp)[as(AS)],CqsS)){
			!discuss(Temp,Dialogue)
		}
		!check_cqs(Sender,Dialogue).
	
+!responseJustify(Sender,[defeasible_rule(C,S)[as(AS)]|Premises],Dialogue): .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, ","  ,[defeasible_rule(C,S)[as(AS)],Premises],")")  .
//	<- .print("I have no argument for or against it: ", Dialogue).


+!responseJustify(Sender,[Content],Dialogue): has_argument_against(Content,Arg) & contrary(C,Comp) & not(inCS(Comp)) & .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, "," , Content,")")
	<-	//.print("## I have an argument against it: ", Arg);
		performatives.send(Sender,question,Content[dialogue(Dialogue)]).
		
+!responseJustify(Sender,[Content],Dialogue): has_argument_against(Content,Arg) & contrary(C,Comp) & inCS(Comp) & .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, ","  , Content,")").
//	<-	.print("## I don't have another argument against it: ", Arg).
	
+!responseJustify(Sender,[Content[_]],Dialogue) : .my_name(MyName) & .print("Received Message:  JUSTIFY(",Sender, ",", MyName, ","  , Content,")")
	<-	//.print("## I have no argument for or against it: ");
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]);
		!check_subject(Sender,Dialogue).
		
		
/* Response to a QUESTION */

+!respondQuestion(Sender,Content,D): argument(Content,Justification) & .my_name(MyName) & .print("Received Message:  QUESTION(",Sender, ",", MyName, ","  ,Content,")")
<- 	    allAgents(Ag)[artifact_id(A)];
		.term2string(AgT,Ag);
	    performatives.send(AgT,justify,justify(Justification,D)).
	    
	    

/* Store the next information to discuss */
+!discuss(Content,Dialogue): has_argument_against(Content,[Arg]) & list_cqs2discuss(List) & not(inCS(Arg))
	<- .concat(List,[Content],ListTemp);
		-+list_cqs2discuss(ListTemp).
		//.print("I have an argument against -- Added to discuss -->> ", Content).
		
+!discuss(Content,Dialogue): has_argument(Content,Arg) | inCS(Content).
	//<- .print("I aswered by myself -->> ", Content).
	
+!discuss(Content,Dialogue): true.
	//<- .print("I dont know the answer -->> ", Content).


/* Check Critical Questions */

+!check_cqs(Sender,Dialogue): list_cqs2discuss(List) & not(empty(List))
	<-	//.print("Lista de Cqs:", List);
		!talk_about(List,Dialogue).

+!talk_about([First|Rest],Dialogue): has_argument_against(First,[Arg])
	<- 	-+list_cqs2discuss(Rest)
		!send(Sender,assert,Arg[dialogue(Dialogue)]).

+!talk_about([First],Dialogue): has_argument_against(First,[Arg])
	<- 	-+list_cqs2discuss(Rest)
		!send(Sender,assert,Arg[dialogue(Dialogue)]).

+!talk_about([],Dialogue).



/* ACCEPT */
+!receiveAccept(Sender,Content[dialogue(Dialogue),source(Source)]): subject(Content,Dialogue) & .my_name(MyName) & .print("Received Message:  ACCEPT(",Sender, ",", MyName, "," ,Content,")")
	<- !closedialogue(Dialogue).
	
+!receiveAccept(Sender,Content[dialogue(Dialogue),source(Source)]): not(subject(Content,Dialogue)) & .my_name(MyName) & .print("Received Message:  ACCEPT(",Sender, ",", MyName, ","  ,Content,")").
	//<- .print("The other agent accepted ", Content, ", so we need to continue the dialogue!").


/* Check Subject */
+!check_subject(Sender,Dialogue): agents(Agents) & .term2string(AgentsT,Agents) & .nth(0,AgentsT,cs(_,CS)) & .nth(0,CS,Content)
	<- 	!add_bb(CS);
		?has_argument(Content,Arg);
		//.print("I accept ", Content);
		performatives.send(Sender,accept,Content[dialogue(Dialogue)]).
	
+!check_subject(Sender,Dialogue)
	<- //.print("I refuse ", Sub);
		performatives.send(Sender,refuse,Content[dialogue(Dialogue)]).
	
+!add_bb([F|R])	<- +F; !add_bb(R).
+!add_bb([F])	<- +F.
+!add_bb([]).

	