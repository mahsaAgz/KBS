package Exercise;

import jess.JessException;
import jess.Rete;

public class monkey_banana {

	public static void main(String[] args) {
		try {
			String path="src/Exercise/";
	       	Rete engine = new Rete();
	        engine.reset();
            engine.batch(path + "monkey_banana.clp");

            engine.eval("(run)");
		}
		catch(JessException e) {
			e.printStackTrace();
			
		}
	}

}

