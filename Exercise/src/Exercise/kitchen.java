package Exercise;

import jess.JessException;
import jess.Rete;

public class kitchen {

	public static void main(String[] args) {
		try {
			String path="src/Exercise/";
	       	Rete engine = new Rete();
	        engine.reset();
	        engine.eval("(reset)");
	        engine.eval("(watch facts)");
            engine.batch(path + "kitchen.clp");
            
            engine.eval("(run)");
					
		}
		catch(JessException e) {
			e.printStackTrace();
			
		}
	}

}

