package midterm;

import jess.JessException;
import jess.Rete;
import jess.Value;

public class midterm {
    public static void main (String[] unused) {
        try {
        	 String path="src/midterm/";
        	 Rete engine = new Rete();
             engine.reset();
             
//             engine.eval("(watch facts)");
//             engine.eval("(watch rules)");
             //engine.eval("(watch activations)");
        
             
             System.out.println("Mahsa Aghazadeh 20234622 Midterm Exam\n");
             // Load rule files\
             engine.batch(path + "question3.clp");
//             engine.batch(path + "data.clp");
//             engine.batch(path + "rules.clp");

             engine.eval("(run)");
        } catch (JessException ex) {
            System.err.println(ex);
        }
    }
}
