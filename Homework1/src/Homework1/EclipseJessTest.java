package Homework1;
import jess.*;
public class EclipseJessTest {
	public static void main(String[] args) {
		
		String wall_data= "src/Homework1/wall-data.clp";
		String wall_rules= "src/Homework1/wall-rules.clp";
		String wall_templates= "src/Homework1/wall-temps.clp";
		try {  
		    // Step 1: Create a Jess engine instance
		    Rete engine = new Rete();

		    // Step 2: Set up the Jess environment
		    // Uncomment to enable fact and rule watching.
		    engine.eval("(watch facts)");
		    engine.eval("(watch rules)");


		    // Reset the Jess environment (clear any previous facts/rules).
		    engine.eval("(clear)");
		    engine.eval("(reset)");
		    

		    // Step 3: Load Jess rule and data files
		    // Ensure the file paths are correct.
		    engine.batch(wall_templates);
		    engine.batch(wall_data);
		    engine.batch(wall_rules);
		    

		    // Step 4: Run the Jess engine
		    // Uncomment to run the engine after loading files.
		    engine.eval("(run)");

		
		    // Additional commands (optional)
		    // Use to inspect facts after running the engine:
//engine.eval("(facts)");

		}
		catch(JessException ex){
			ex.printStackTrace();
			
		}

		
	}

}
