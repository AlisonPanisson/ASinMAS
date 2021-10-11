// Internal action code for project data_access_control

package jia;

import jason.asSemantics.*;
import jason.asSyntax.*;

public class get_unifier extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	
       // Get Parameters        
       Literal arg = Literal.parseLiteral(args[0].toString());
       Literal as_name = arg.getAnnot("as");
       Literal as = null;
       
//       System.out.println(args[0].toString());
        
       // Search the argumentation scheme in the Agent's BB
       PredicateIndicator ind = new PredicateIndicator("defeasible_rule", 2);
       java.util.Iterator<Literal> it = ts.getAg().getBB().getCandidateBeliefs(ind);
       while (it.hasNext()) {
    	   Literal temp = it.next();
    	   if (temp.hasAnnot(as_name)) {
				as = Literal.parseLiteral(temp.toString().replace(":- true", ""));
    	   }
       }
            
        Unifier u = new Unifier();
        u.unifies(arg, as);   // get the unifier function (Var:Term)
//        System.out.println("Unifier:" + u);
//        if(u.size()>0) {
//        	System.out.println("first");
        	return un.unifies(args[1], new StringTermImpl(u.toString()));
//        } else {
//        	System.out.println("second");
//        	return un.unifies(args[1], new StringTermImpl("[]"));
//        }
//        
        
    }

}
