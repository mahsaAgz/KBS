package Part3;

import jess.*;



public class Part3 {

    public static void main(String[] args) {
        try {
            // Initialize Jess rule engine
            Rete engine = new Rete();
            engine.reset();
            System.out.println("Mahsa Aghazadeh 20234622 Part 3");
//            engine.eval("(watch facts)");
            // Load rule files
            engine.batch("src/Part3/temps.clp");
            engine.batch("src/Part3/data.clp");
            engine.batch("src/Part3/rules.clp");

            engine.eval("(run)");
            
//            engine.eval("(watch facts)");

        } catch (JessException ex) {
            ex.printStackTrace();
        }
    }
}