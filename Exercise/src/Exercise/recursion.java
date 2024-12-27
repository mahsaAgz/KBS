package Exercise;

import jess.JessException;
import jess.Rete;

public class recursion {

	public static void main(String[] args) {
		try {
			String path="src/Exercise/";
	       	Rete engine = new Rete();
	        engine.reset();
	        engine.eval("(reset)");
	        engine.eval("(watch facts)");
            engine.batch(path + "recursion.clp");
            
            engine.eval("(run)");
					
		}
		catch(JessException e) {
			e.printStackTrace();
			
		}
	}

}

