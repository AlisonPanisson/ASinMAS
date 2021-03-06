// Internal action code for project data_access_control

package jia;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import jason.asSemantics.*;
import jason.asSyntax.*;

public class get_scheme2 extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {

       
    	// Get parameters
       Literal as_name = Literal.parseLiteral(args[0].toString());
       Literal as_annotation = Literal.parseLiteral("as(" + as_name +")");
       ArrayList<Literal> ll = new ArrayList<Literal>();
       
       
       PredicateIndicator ind = new PredicateIndicator("defeasible_rule", 2);
       
       try {
    	   java.util.Iterator<Literal> it = ts.getAg().getBB().getCandidateBeliefs(ind);
    	   
    	   while (it.hasNext()) {
        	   Literal temp = it.next();
        	   if (temp.hasAnnot(as_annotation)) {
        		   ll.add(Literal.parseLiteral(temp.toString().replace(":- true", "")));  	   
        		   }
           }
                         
       // Get and Instantiate the critical questions
    	   ind = new PredicateIndicator("cq", 2);
    	   it = ts.getAg().getBB().getCandidateBeliefs(ind);
    	   
    	   while (it.hasNext()) {
        	   Literal temp = it.next();
        	   if (temp.hasAnnot(as_annotation)) {
        		   ll.add(Literal.parseLiteral(temp.toString().replace(":- true", "")));   
        		   }
           }
    	      	  
    	   return un.unifies(args[1], new StringTermImpl(ll.toString()));
    	   
       } catch (Exception e) {
    	   return un.unifies(args[1], new StringTermImpl("[]"));
       }

    }
}
