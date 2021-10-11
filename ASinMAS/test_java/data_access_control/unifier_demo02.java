package data_access_control;

import static jason.asSyntax.ASSyntax.createAtom;
import static jason.asSyntax.ASSyntax.createLiteral;
import static jason.asSyntax.ASSyntax.createNumber;
import static jason.asSyntax.ASSyntax.createString;
import static jason.asSyntax.ASSyntax.parseLiteral;
import jason.asSemantics.Unifier;
import jason.asSyntax.Literal;

public class unifier_demo02 {

    public static void main(String[] args) throws Exception {
        // create some literals
        Literal utrecht = createLiteral("city", createString("Utrecht"), createNumber(100000), createAtom("nl"));
        Literal stet    = createLiteral("city", createString("St Etienne"), createNumber(200000), createAtom("fr"));
        
        // what follows is the same as Demo1
        
        // tries some unifications
        Literal r = parseLiteral("city(Name, Pop, Country)");
        
        // unifies utrecht and r
        Unifier u = new Unifier();
        System.out.println( u.unifies(utrecht, r) );     // true
        // print the unifier (that is a map from variables to terms)
        System.out.println(u);                           // {Name="Utrecht", Pop=100000, Country=nl}

        // the apply operation replaces variables by values of an unifier
        r.capply(u);
        System.out.println(r.capply(u));                           // city("Utrecht",100000,nl)

        // unifies utrecht and stet
        u.clear();
        System.out.println( u.unifies(utrecht, stet) );  // false
     }
 }
