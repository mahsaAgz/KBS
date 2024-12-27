package Part2;

import jess.*;


public class Part2 {

    public static void main(String[] args) {
        try {
            // Initialize Jess rule engine
            Rete engine = new Rete();
            engine.reset();
            engine.eval("(watch facts)");
            engine.eval("(watch rules)");
            engine.eval("watch activations")      ;      System.out.println("Mahsa Aghazadeh 20234622 Part 2\n");
            engine.batch("src/Part2/temps.clp");
            engine.batch("src/Part2/data.clp");
            engine.batch("src/Part2/rules.clp");

            engine.eval("(run)");
            


        } catch (JessException ex) {
            ex.printStackTrace();
        }
    }
}
