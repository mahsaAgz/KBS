package Class_Exercise_1;
import jess.*;

public class Jess_Java {
    public static void main (String[] unused) {
        try {
            Rete r = new Rete();
            r.eval("(deffunction square (?n) (return (* ?n ?n)))");
            Value v = r.eval("(square 3)");

            System.out.println(v.intValue(r.getGlobalContext()));
        } catch (JessException ex) {
            System.err.println(ex);
        }
    }
}


