// Agent as4eo in project data_access_control

 /* THIS FILE IMPLEMENTS THE ARGUMENTATION SCHEME FROM ROLE TO KNOW [Panisson et al. 2017] */ 

/* Initial assumptions */

reliable(Ag):- not(~reliable(Ag)[_]).

/* AS4RK - Argumentation scheme for Role to Know */
defeasible_rule(conclusion(Conc),[asserts(Ag,Conc),role(Ag,Role),role_to_know(Role,Subj),about(Conc,Subj)])[as(as4rk)].
	cq(cq1,role_to_know(Role,Subj))[as(as4rk)].
	cq(cq2,reliable(Ag))[as(as4rk)].
	cq(cq3,asserts(Ag,Conc))[as(as4rk)].
	cq(cq4,role(Ag,Role))[as(as4rk)]. 
