package data_access_control;

import static jason.asSyntax.ASSyntax.parseFormula;
import static jason.asSyntax.ASSyntax.parseLiteral;
import jason.asSemantics.Agent;
import jason.asSemantics.Unifier;
import jason.asSyntax.Literal;
import jason.asSyntax.LogicalFormula;

import java.util.Iterator;

public class engine_example01 {
	
	    public static void main(String[] args) throws Exception {
	       // create some literals
	       Literal utrecht = parseLiteral("city(\"Utrecht\", 100000, nl)");
	       Literal stet    = parseLiteral("city(\"St Etienne\", 200000, fr)");
	       Literal nl      = parseLiteral("country(nl, \"The Netherlands\")");
	       Literal france  = parseLiteral("country(fr, \"France\")");
	       
	       // put those literals in a belief base
	       Agent ag = new Agent();
	       ag.initAg();
	       ag.getBB().add(utrecht);
	       ag.getBB().add(stet);
	       ag.getBB().add(nl);
	       ag.getBB().add(france);
	       
	       // run a query
	       // create the query using the parser
	       LogicalFormula query = parseFormula("city(Name, Pop, C) & country(C,Country)");
	       
	       // get all solutions
	       // a solution is a unifier for the query
	       Iterator<Unifier> i = query.logicalConsequence(ag, new Unifier());
	       while (i.hasNext()) {
	           Unifier solution = i.next();
	           System.out.println(solution);
	       }
	       
	       // prints
	       //  {Name="St Etienne", Pop=200000, C=fr, Country="France"}
	       //  {Name="Utrecht",    Pop=100000, C=nl, Country="The Netherlands"}

	    }
	}

