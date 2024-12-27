package Class_Exercise_1;

import jess.*;
import javax.swing.*;
import javax.swing.border.EmptyBorder;

import java.awt.*;

public class Jess_Java2 {
    public static void main(String[] args) {
        // Initialize the Jess engine
        try {
            Rete r = new Rete();  // Initialize Jess Rete engine
            r.eval("(deftemplate point (slot x)(slot y))");  // Define a template called "point"

            Fact f = new Fact("point", r);  // Create a new fact of the "point" template
            f.setSlotValue("x", new Value(21, RU.INTEGER));  // Set slot x to 21
            f.setSlotValue("y", new Value(10, RU.INTEGER));  // Set slot y to 10
            r.assertFact(f);  // Assert fact into working memory
            r.eval("(facts)");  // Print facts from working memory

            // Create and show GUI
            SwingUtilities.invokeLater(() -> {
                createAndShowGUI();
            });

        } catch (JessException ex) {
            System.err.println(ex);
        }
    }

    private static void createAndShowGUI() {
        // Create the main window (JFrame)
    	final JFrame guiFrame=new JFrame();
		guiFrame.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE);
		guiFrame.setTitle ("Wall Selection GUI");
		guiFrame.setSize (800, 600);
		guiFrame.setLayout (new BorderLayout());
		
        
        final JPanel contentPanel = new JPanel();
		contentPanel.setLayout(new GridLayout(1,2));
		contentPanel.setBorder(new EmptyBorder(10, 10, 10, 10));
		
		guiFrame.add(contentPanel, BorderLayout.CENTER);
		// Request
		final JPanel reqPanel = new JPanel();
				
		reqPanel.setLayout(new BoxLayout(reqPanel, BoxLayout.Y_AXIS));
		// set border for the panel
		reqPanel.setBorder(BorderFactory.createTitledBorder(
		BorderFactory.createEtchedBorder(), "Wall Requirements"));
				
				
		// Results
				
		final JPanel resultPanel = new JPanel();
		//Add require and result panels to content panel
		contentPanel.add(reqPanel);
		contentPanel.add(resultPanel);
				
		guiFrame.add(contentPanel, BorderLayout.CENTER);
		resultPanel.setLayout(new BoxLayout(resultPanel, BoxLayout.Y_AXIS));
		// set border for the panel
		resultPanel.setBorder(BorderFactory.createTitledBorder(
		BorderFactory.createEtchedBorder(), "Results"));

		final JPanel pnPanel = new JPanel();
		JLabel nameLbl = new JLabel("Requirement");
		//Create a text field with a specified number of columns, 10
		final JTextField pname = new JTextField(10);
		//Set horizontal alignment of text
		pname.setHorizontalAlignment(JTextField.LEFT);
		//Set font style
		pname.setFont(new java.awt.Font("GilSans", Font.PLAIN, 12));
		pnPanel.add(nameLbl);
		pnPanel.add(pname);
		reqPanel.add(pnPanel);
		
		// Button to show the result
        JButton showResultButton = new JButton("Show Me the Result");
        reqPanel.add(showResultButton);

        // Text area for displaying results
        JTextArea resultTextArea = new JTextArea(10, 30);
        resultTextArea.setEditable(false);  // Make the text area non-editable
        JScrollPane scrollPane = new JScrollPane(resultTextArea);
        resultPanel.add(scrollPane);

        
		
        // Add the content panel to the frame
        guiFrame.getContentPane().add(contentPanel);

        // Display the window
        guiFrame.setVisible(true);
    }
}
