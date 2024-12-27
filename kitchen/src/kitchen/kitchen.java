package kitchen;

import jess.*;
import javax.swing.*;
import java.awt.*;


public class kitchen {
	  public static void main(String[] args) {
	        try {
	            // Initialize Jess rule engine
	            Rete engine = new Rete();
	            engine.reset();

	            // Load rule files
	            engine.batch("src/kitchen/tmp-kitchen.clp");
	            engine.batch("src/kitchen/data-kitchen.clp");
	            engine.batch("src/kitchen/rule-kitchen.clp");
	            engine.eval("(facts)");
	            engine.eval("(watch rules)");
	            engine.eval("(run)");
	            
	        }
	        catch (JessException ex) {
	            ex.printStackTrace();
	        }
	  }
	

}
