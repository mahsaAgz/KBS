package Class_Exercise_1;
import jess.*;
import javax.swing.*;
import javax.swing.border.EmptyBorder;

import java.awt.*;

public class max_distance {
	
	public void main(String[] args) throws JessException {
		String clp_file = "src/max_dist.clp";
		
		Rete engine=new Rete();
		
		engine.reset();
		engine.batch(clp_file);
		
		
	}

}
