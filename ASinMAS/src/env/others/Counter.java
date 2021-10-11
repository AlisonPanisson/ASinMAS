package others;

//public class Counter {
//	
//	public static void main(String []args) {
//		CounterClass .setCounter(Integer.parseInt(args[0]));
//	}
//}
//	
	
public final class Counter  {
	
	private Counter () { // private constructor
        counter = 0;
    }
	
    private static int counter;
    
    public static int getCounter() {
        return counter;
    }
    
    public static void setCounter(int val) {
        counter = val;
    }
    
    public static void addCounter() {
    	counter = counter+1;
    }
    
}

