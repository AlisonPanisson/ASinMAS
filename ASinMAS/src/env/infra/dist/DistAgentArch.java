package infra.dist;

import jason.JasonException;
import jason.asSemantics.Message;
import jason.mas2j.ClassParameters;
import jason.runtime.Settings;
import others.Counter;
import c4jason.*;
import cartago.*;


public class DistAgentArch extends jason.architecture.AgArch {
	
	public Integer countMessages = 0;
	
//	public ArrayList<PendingMessages> pendingMessages;  
	
	public DistAgentArch() {
		super();
//		this.pendingMessages = new ArrayList<PendingMessages>();
	}

	/**
	 * Initiates the agent including it into a CArtAgO environment.
	 * @throws Exception 
	 */
	public void initAg(String agClass, ClassParameters bbPars, String asSrc, Settings stts) throws Exception {
		super.init();
		//super.initAg(agClass, bbPars, asSrc, stts);
		// initBridge(); // I commented This line 		
	}
	
	
	
	/**
	 * Stores a message in a temporary buffer that is consulted by the agent's "checkMail" action during the BDI cycle (second step).
	 * @param msg Message to be stored.
	 */
	public void receiveMsg(Message msg){
		System.out.println(msg);
	} 

	/**
	 * This agent architecture overrides
	 * Jason's  <i>AgArch</i> <i>checkMail</i> method that is responsible for verifying the agent's messages from
	 * it's inbox. In the present implementation, the mails are obtained form a local buffer. 
	 */
	@Override
	public void checkMail(){
		super.checkMail();
//		System.out.println("MESSAGE RECEBIDA:" + getTS().getC().getMailBox());
	}

	/**
	 * Sends a message to another agent using a instance of the CArtAgO artifact referenced in MAILBOX_ARTIFACT variable.
	 * The target agent is indicated in the message body. The message taken as parameter is an instance of the Jason Message class.
	 */
	@Override
	public void sendMsg(Message message) throws Exception{
		super.sendMsg(message);
		Counter.addCounter();
		
		// ADD to Evaluation: 
		
		//System.out.println("MESSAGE Number:" + Counter.getCounter());
		//System.out.println("Length:" + message.getPropCont().toString().length()); //descomentar para mostrar tamanho das msg
	}
	
//	private class PendingMessages {
//		
//		private String msgId;
//		private ArrayList<String> agents;
//		
//		public PendingMessages(String msgId, ArrayList<String> agents) {
//			this.msgId = msgId;
//			this.agents= agents;
//		}
//
//		public String getMsgId() {
//			return msgId;
//		}
//
//		public void setMsgId(String msgId) {
//			this.msgId = msgId;
//		}
//
//		public ArrayList<String> getAgents() {
//			return agents;
//		}
//
//		public void setAgents(ArrayList<String> agents) {
//			this.agents = agents;
//		}
//		
//		
//	}

	
}


