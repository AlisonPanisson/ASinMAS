// Internal action code for project data_access_control

package jia;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class show_unifier extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        System.out.println("Unifier : " + un);                         
        return true;
    }
}
