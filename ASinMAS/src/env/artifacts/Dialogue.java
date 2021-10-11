package artifacts;

import java.util.ArrayList;
import java.util.List;

import cartago.*;

public class Dialogue extends Artifact {

	private ArrayList<Tuple> agentsTuples;
	private ArrayList<String> agents; 
	private ArrayList<String> pendingAgents;
	
		
	void init(Object[] args) {
		
		agentsTuples = new ArrayList<Tuple>();
		agents = new ArrayList<String>();
		pendingAgents = new ArrayList<String>();
		
		for (int i = 0; i < args.length; i++) {
			this.agentsTuples.add(new Tuple("cs", args[i].toString(), new ArrayList<String>()));
			this.agents.add(new Tuple("cs", args[i].toString(), new ArrayList<String>()).toString());
			this.pendingAgents.add(args[i].toString());
		}
		
		defineObsProperty("id", this.getId().toString());
		defineObsProperty("agents", agents.toString());
		defineObsProperty("status", "OPEN");
	}

	@OPERATION
	void closedialogue() {
		ObsProperty status = getObsProperty("status");
		status.updateValue("CLOSE");
	}
	
	
	@OPERATION
	void addCS(Object update) {
		if (update.getClass().isArray()) {
//			System.out.println("Lista");
			addListCS((Object[]) update);
		} else {
//			System.out.println("não lista");
			addOneCS(update);
		}
	}

	
	
//	@OPERATION
//	void addCS(Object[] update) {
//		System.out.println(update.toString());
//		if (update.getClass().isArray()) {
//			addListCS(update);
//		} else {
//			addOneCS(update);
//		}
//	}
	
//	@OPERATION
//	void addCS(String update) {
//		System.out.println(update);
//			addOneCS(update);
//	}

	private void addListCS(Object[] update) {
		Tuple temp = null;
		for (int i = 0; i < agentsTuples.size(); i++) {
			temp = agentsTuples.get(i);
			if (temp.getContent(0).equals(getCurrentOpAgentId().toString())) {
				ArrayList<String> t = (ArrayList<String>) temp.getContent(1);
				for (int j = 0; j < update.length; j++) {
					t.add(update[j].toString());
				}
				this.agentsTuples.set(i, new Tuple("cs", temp.getContent(0), t));
				this.agents.set(i, new Tuple("cs", temp.getContent(0), t).toString());
				ObsProperty agentsCS = getObsProperty("agents");
				agentsCS.updateValue(agents.toString());
			}
		}
	}

	private void addOneCS(Object update) {
		Tuple temp = null;
		for (int i = 0; i < agentsTuples.size(); i++) {
			temp = agentsTuples.get(i);
			if (temp.getContent(0).equals(getCurrentOpAgentId().toString())) {
				ArrayList<String> t = (ArrayList<String>) temp.getContent(1);
				t.add(update.toString());
				this.agentsTuples.set(i, new Tuple("cs", temp.getContent(0), t));
				this.agents.set(i, new Tuple("cs", temp.getContent(0), t).toString());
				ObsProperty agentsCS = getObsProperty("agents");
				agentsCS.updateValue(agents.toString());
			}
			
		}
	}

	@OPERATION
	void removeCS(Object update) {
		Tuple temp = null;
		for (int i = 0; i < agentsTuples.size(); i++) {
			temp = agentsTuples.get(i);
			if (temp.getContent(0).equals(getCurrentOpAgentId().toString())) {
				ArrayList<String> t = (ArrayList<String>) temp.getContent(1);
				t.remove(update.toString());
				this.agentsTuples.set(i, new Tuple("cs", temp.getContent(0), t));
				this.agents.set(i, new Tuple("cs", temp.getContent(0), t).toString());
				ObsProperty agentsCS = getObsProperty("agents");
				agentsCS.updateValue(new MyStr(agents.toString()));
			}
			;
		}
	}

	@OPERATION
	void addAgent(String agent) {
		Boolean contains = false;
		for (Tuple temp : this.agentsTuples) {
			if (temp.getContent(0).equals(agent)) {
				contains = true;
				break;
			}
			;
		}
		if (!contains) {
			this.agentsTuples.add(new Tuple("cs", agent, new ArrayList<String>()));
			this.agents.add(new Tuple("cs", agent, new ArrayList<String>()).toString());
			ObsProperty agentsCS = getObsProperty("agents");
			agentsCS.updateValue(new MyStr(agents.toString()));
		}
	}

	@OPERATION
	void removeAgent(String agent) {
		for (Tuple temp : this.agentsTuples) {
			if (temp.getContent(0).toString().equals(agent)) {
				this.agentsTuples.remove(temp.toString());
				this.agents.remove(temp.toString());
				ObsProperty agentsCS = getObsProperty("agents");
				agentsCS.updateValue(new MyStr(agents.toString()));
			}
		}
	}
	
	
	@OPERATION
	void confirmAgent(String agent) {
		this.pendingAgents.remove(agent);
		//System.out.println("Pendinng Agents: " + pendingAgents.toString());
		if(pendingAgents.isEmpty()){
			signal("continueDialogue", getId().toString());
		}
	}

	@OPERATION
	void allAgents(OpFeedbackParam<String> res) {
		ArrayList<String> agent = new ArrayList<String>();
		for (Tuple temp : this.agentsTuples) {
			agent.add(temp.getContent(0).toString());
		}
		agent.remove(getCurrentOpAgentId().toString());
		res.set(agent.toString());
	}
	

	class MyStr implements others.ToProlog {
		String s;

		public MyStr(String s) {
			this.s = s;
		}

		public String getAsPrologStr() {
			return s;
		}
	}

}
