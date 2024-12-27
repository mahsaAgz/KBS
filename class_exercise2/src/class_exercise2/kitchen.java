package class_exercise2;

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
	            engine.batch("src/class_exercise2/tmp-file.clp");
	            engine.batch("src/class_exercise2/data-file.clp");
	            engine.batch("src/class_exercise2/rule-file.clp");
	            engine.eval("(facts)");
	            engine.eval("(watch rules)");
	            engine.eval("(run)");
	            
	        }
	        catch (JessException ex) {
	            ex.printStackTrace();
	        }
	  }
	

}
