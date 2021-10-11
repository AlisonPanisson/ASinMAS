

// IMPLEMENT A MODULE

/* Rules */
has_argument(Content,Justification):- argument(Content,Justification) & not(.empty(Justification)).
has_argument_against(Content,Comp,Justification):- comp(Content,Comp) & argument(Comp,Justification) & not(.empty(Justification)).


/* ##### Response to Assert ##### */

/* Get information about the task */
+!responseAssert(Sender,Content[dialogue(D)]): Content=execute(_,Task) & not(can_be_transferred(Task)) & not(~can_be_transferred(Task))
	<- 	//isInstanceOf(Task,"TemporalReallocableTask",IsTR);
		if(reallocableTask(Task)){
			+can_be_transferred(Task);			
		}else{
			+~can_be_transferred(Task);
		}
		!responseAssert(Sender,Content[dialogue(D)]). 
		
/*  If an agent receive an assert message and the agent has an acceptable argument to this claim
 *  the agent accept the claim
 */	
+!responseAssert(Sender,Content[dialogue(D)]): has_argument(Content,Justification)
	<-	.print("Accept - I have an acceptable argument: ", Justification, " to: ", Content );
//		lookupArtifact(D,A);
//	    focus(A);
		!acceptClaim(Sender,Content[dialogue(D)]).	
	
/*  If an agent receives an assert message and the agent has not an acceptable argument against this claim
 *  the agent accept the claim
 */
+!responseAssert(Sender,Content[dialogue(D)]): not has_argument(Content,Justification) & not has_argument_against(Content,Comp,Justification)
	<-	.print("Accept - I have not an acceptable argument against, then I accept:", Content );
//		lookupArtifact(D,A);
//	    focus(A);
		!acceptClaim(Sender,Content[dialogue(D)]).	

/*  If an agent receive an assert message and the agent has an acceptable argument against this claim
 *  the agent questions the other agent to receive the justification to this claim
 */
+!responseAssert(Sender,Content[dialogue(D)]): has_argument_against(Content,Comp,Justification)
	<-	.print("Refuse - I have an acceptable argument against: ", Justification, " to: ", Content );
	// I commented this
		//lookupArtifact(D,A);
	    //focus(A);
//		allAgents(Teste)[artifact_id(D)];
//	    .my_name(Myname);
//	    .member(cs(Myname,CS),Teste);
	    performatives.send(Sender,question,Content[dialogue(D)]);.

/*  The agent remove of the her commitment store the complement previously asserted (if it exists)
 *  and send for all agent in the dialogue that he accept the claim 
 */    
+!acceptClaim(Sender,Content[dialogue(D)]): true 
	<- 	?comp(Content,NContent);
//	    ?agents(Teste)[artifact_id(A)];
//	    .my_name(Myname);
//	    .member(cs(Myname,CS),Teste);
//	    if(.member(NContent,CS)){
//	    	removeCS(NContent)[artifact_id(A)];
//	    }
		performatives.send(D,accept,Content[dialogue(D)]);
		!continue_task_reallocation(Sender,Content[dialogue(D)]).
	    
/* ##### Response Justify ##### */ //TRABALHAR AQUI...

/* The agent verifies the conclusion of the inference rule */
+!responseJustify(Sender,[H[dialogue(D)]|T]): H=defeasible_rule(Head,Body) | H=strict_rule(Head,Body)
	<- 	!responseJustifyLiteral(Sender,D,Head).
	
+!responseJustify(Sender,[]): true  // #### Alterado
	<- 	// I commented Here
//		?agents(Teste)[artifact_id(A)];
//	    .member(cs(Sender,CS),Teste);
//	    .nth(0,CS,Content[dialogue(D)]); 
		!responseJustifyLiteral(Sender,D,Content).
	
/* If the agent has an acceptable argument to the content the agent accept the claim */
+!responseJustifyLiteral(Sender,D,Content): has_argument(Content,Justification)
	<-	!acceptClaim(Sender, Content[dialogue(D)]).
	
/* If the agent has an acceptable argument to the content the agent accept the claim */
+!responseJustifyLiteral(Sender,D,Content):  not has_argument(Content,Justification) & not has_argument_against(Content,Comp,Justification)
	<-	!acceptClaim(Sender, Content[dialogue(D)]).
	
/* If the agent has an acceptable argument against the agent justifies her previously assertion */	
+!responseJustifyLiteral(Sender,D,Content): has_argument_against(Content,Comp,Justification)
	<-	.print("The justification do not changed my conclusion!");
//		?agents(Teste)[artifact_id(A)];
//		.my_name(Myname);
//		.member(cs(Myname,CS),Teste);
//	    if(.member(Justification,CS)){
	    	!end_dialogue(D,Comp);
//	    }else{
	    	performatives.send(D,justify,Justification).
//	    }.
	    
