// Internal action code for project data_access_control

package jia;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import jason.asSemantics.*;
import jason.asSyntax.*;

public class decodification extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {

       
    	// Get parameters
       Literal as_name = Literal.parseLiteral(args[0].toString());
       String oldUnifier = args[1].toString();
       Literal as_annotation = Literal.parseLiteral("as(" + as_name +")");
       Literal ll = null;
       
       //System.out.println("Argumentation Scheme Name: " + as_name);

      // Set the unifier
       Map<VarTerm, Term> unifier = new HashMap<VarTerm, Term>();
       oldUnifier = oldUnifier.substring(2, oldUnifier.length()-2);
       String[] keyValuePairs = oldUnifier.split(", ");             
       for(String pair : keyValuePairs){
           String[] entry = pair.split("=");    
           unifier.put((VarTerm)Literal.parseLiteral(entry[0].trim()), Literal.parseLiteral(entry[1].trim()));          //add them to the hashmap and trim whitespaces
       }
       Unifier uFinal = new Unifier();
       uFinal.setFunction(unifier);
                     
       // Get and Instantiate the critical questions
       PredicateIndicator ind = new PredicateIndicator("defeasible_rule", 2);
       
       try {
    	   java.util.Iterator<Literal> it = ts.getAg().getBB().getCandidateBeliefs(ind);
    	   
    	   while (it.hasNext()) {
        	   Literal temp = it.next();
        	   if (temp.hasAnnot(as_annotation)) {
        		   ll = Literal.parseLiteral(Literal.parseLiteral(temp.toString().replace(":- true", "")).capply(uFinal).toString());    	   
        		   }
           }
    	  
    	   return un.unifies(args[2], ll);
    	   
       } catch (Exception e) {
    	   return un.unifies(args[2], new StringTermImpl("[]"));
       }

    }

}
