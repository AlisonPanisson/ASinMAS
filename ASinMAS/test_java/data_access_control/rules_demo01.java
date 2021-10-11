package data_access_control;

import static jason.asSyntax.ASSyntax.parseLiteral;
import static jason.asSyntax.ASSyntax.parseRule;
import jason.asSemantics.Agent;
import jason.asSemantics.Unifier;
import jason.asSyntax.Literal;
import jason.asSyntax.Rule;

import java.util.Iterator;


public class rules_demo01 {
	
	    public static void main(String[] args) throws Exception {
	        Literal utrecht = parseLiteral("city(\"Utrecht\", 100000, nl)");
	        Literal stet    = parseLiteral("city(\"St Etienne\", 200000, fr)");
	        
	        Rule    good    = parseRule("good(X) :- city(X,H,C) & H < 150000.");
	        
	        // put those literals in a belief base
	        Agent ag = new Agent();
	        ag.initAg();
	        ag.getBB().add(utrecht);
	        ag.getBB().add(stet);
	        ag.getBB().add(good); // add a rule
	        
	        // run a query
	        // create the query using the parser
	        Literal query = parseLiteral("good(City)");
	        
	        // get all solutions
	        // a solution is a unifier for the query
	        Iterator<Unifier> i = query.logicalConsequence(ag, new Unifier());
	        while (i.hasNext()) {
	            Unifier solution = i.next();
	            Literal q = query.copy();
	            System.out.println(q.capply(solution));
	        }
	    }
	}