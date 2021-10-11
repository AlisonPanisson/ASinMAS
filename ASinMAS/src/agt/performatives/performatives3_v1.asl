// Agent locutions in project performatives

number_of_dialogues(0).
ctj(Content):- true.
acceptdialogue(X):- true.

/* ######################################## Receiving ######################################## */ 

/* ######## OpenDialogue ######### */
@kqmlReceivedOpenDialogue
+!kqml_received(Sender, opendialogue, Content, MsgId)
   <- 	.add_nested_source(dialogue(Content), Sender, CA);
   		+CA. 
   		
/* ######## CloseDialogue ######### */   		
@kqmlReceivedCloseDialogue
+!kqml_received(Sender, closedialogue, Content, MsgId)
   <- 	.add_nested_source(dialogue(Content), Sender, CA);
   		-CA;
   		.my_name(MyName);
   		.print("Received Message:  CLOSEDIALOGUE(",Sender,",",MyName,")").
   		
/* ######## AcceptDialogue ######### */   	 //FAZER AINDA	
@kqmlReceivedAcceptDialogue
+!kqml_received(Sender, acceptdialogue, Content, MsgId)
   <- 	lookupArtifact(Content,A);
        focus(A);
   		confirmAgent(Sender)[artifact_id(A)].
   		
   		
 +continueDialogue(ID) <- !!continueDialogue(ID).
 
 //CONTINUAR APARTIR DO CONTINUE DIALOGUE
   		
  
/* ######## RefuseDialogue ######### */   	 //FAZER AINDA	
@kqmlReceivedRefuseDialogue
+!kqml_received(Sender, refusedialogue, Content, MsgId)
   <- 	lookupArtifact(Content,A);
        focus(A);
        removeAgent(Sender)[artifact_id(A)].  		
 
/* ######## Assert ######### */  		
@kqmlReceivedAssert
+!kqml_received(Sender, assert, Content, MsgId): .add_nested_source(Content, Sender, CA)
   <- 	!responseAssert(Sender,CA). // IMPLEMENT A MODULE

/* ######## Accept ######### */
@kqmlReceivedAccept
+!kqml_received(Sender, accept, Content, MsgId): .add_nested_source(Content, Sender, CA)
   <- 	+CA;
   	 	!receiveAccept(Sender,CA). // IMPLEMENT A MODULE
 
/* ######## Retract ######### */  	 	
@kqmlReceivedRetract
+!kqml_received(Sender, retract, Content, MsgId): .add_nested_source(Content, Sender, CA)
   <- 	-CA.
   	 	

/* ######## Question ######### */
@kqmlReceivedQuestion
+!kqml_received(Sender, question, Content[dialogue(D)], MsgId): ctj(Content)
   <- 	!respondQuestion(Sender,Content,D).
        	 	
/* ######## Justify ######### */
@kqmlReceivedJustify
+!kqml_received(Sender, justify, justify(Content,D), MsgId): .list(Content)
   <- 	!responseJustify(Sender,Content,D). 

        
@kqmlReceivedJustifyList1
+!add_all_kqml_received(_,[]).   

@kqmlReceivedJustifyList2
+!add_all_kqml_received(Sender,[H|T])
   :  .literal(H) & 
      .ground(H)
   <- .add_nested_source(H, Sender, CA);
      +CA;
      !add_all_kqml_received(Sender,T).

@kqmlReceivedJustifyList3
+!add_all_kqml_received(Sender,[_|T])
   <- !add_all_kqml_received(Sender,T).
   	 	

/* ######## Challenge ######### */
@kqmlReceivedChallenge
+!kqml_received(Sender, challenge, Content[dialogue(D)], MsgId): ctj(Content)
   <- 	?argument(Content,Justification);
	    allAgents(Ag)[artifact_id(A)];
		.term2string(AgT,Ag);
	    performatives.send(AgT,justify,Justification);
	    ?comp(Content,CompContent);
	    .add_annot(CompContent, dialogue(D), CompCA);
	    .add_nested_source(CompCA, Sender, CompCA2);
	    !responseChallenge(Sender,CompCA2).	  // IMPLEMENT A MODULE
	    
@kqmlReceivedPass
+!kqml_received(Sender, pass, _, MsgId)
   <- 	!responseAssert(Sender,[]). 
	    
	    
/* ######################################## Sending ######################################## */  
	
/* Send challenge */
+!send(Aid,challenge,Content[dialogue(Did)]): true
	<- 	
		lookupArtifact(Did,A);
	    focus(A);
	    ?comp(Content,ContentN);
	    addCS(ContentN)[artifact_id(A)];
	    allAgents(Agents)[artifact_id(A)];
	    .term2string(Temp,Agents);
//	    .term2string(D,Did);
	    .add_annot(Content, dialogue(Did), ContentCA);
	    .add_annot(ContentN, dialogue(Did), ContentNCA);
	    performatives.send(Aid,challenge,ContentCA);
	    performatives.send(Temp,assert,ContentNCA).
	    
	      
/* Send assert */
+!send(Aid,assert,Content[dialogue(Did)]): true
	<- 	lookupArtifact(Did,A)
		focus(A);
		allAgents(Ag)[artifact_id(A)];
		.term2string(AgT,Ag);
		addCS(Content);
		addCS([joao,maria,teste])
		performatives.send(AgT,assert,Content[dialogue(Did)]).
		
/* Send question */
+!send(Aid,question,Content[dialogue(Did)]): true
	<- 	lookupArtifact(Did,A)
		focus(A);
		allAgents(Ag)[artifact_id(A)];
		.term2string(AgT,Ag);
		performatives.send(AgT,question,Content[dialogue(Did)]).


/* Open the dialogue  */ 
+!opendialogue(Agents,Subject): true
	<- 	?number_of_dialogues(X);
		-+number_of_dialogues(X+1);
		?number_of_dialogues(N);
		.concat("d",N,Name);
		makeArtifact(Name,"artifacts.Dialogue",[Agents],D);
	    focus(D);
	    +subject(Subject,Name);
	    ?id(ID)[artifact_id(D)];
	    allAgents(Ag)[artifact_id(D)];
	    .term2string(Temp,Ag);
	    performatives.send(Temp,opendialogue,ID);
	    .my_name(AName);
	    confirmAgent(AName)[artifact_id(D)]; 
	    +dialogue(ID).
	    
/* Close the dialogue  */ 
+!closedialogue(D1): true  //Did is the dialogue identifier
	<-  lookupArtifact(D1,D);
		focus(D);
		closedialogue[artifact_id(D)]; //close the dialogue
		 allAgents(Ag)[artifact_id(D)];
	    .term2string(Temp,Ag);
	    performatives.send(Temp,closedialogue,D1);
	    -dialogue(D1).

+!create_artifact_Dialogue(Name,D,T)
	<- 	makeArtifact(Name,"artifacts.Dialogue",[T],D).
   	 		

