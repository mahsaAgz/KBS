package Homework1;

import jess.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.border.EmptyBorder;
import java.util.ArrayList;
import java.util.Iterator;

public class HomeWorkGUI {

    private static DefaultListModel<String> model = new DefaultListModel<>();
    private static ArrayList<String> selectedWall = new ArrayList<>(); // List to store paths of images

    public static void main(String[] args) {
        try {
            // Initialize Jess rule engine
            Rete engine = new Rete();
            engine.reset();

            // Load rule files
            engine.batch("src/Homework1/wall-temps.clp");
            engine.batch("src/Homework1/wall-data.clp");
            engine.batch("src/Homework1/wall-rules.clp");

            // GUI Setup
            final JFrame guiFrame = new JFrame();
            guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            guiFrame.setTitle("Wall Selection GUI");
            guiFrame.setSize(1000, 800);
            guiFrame.setLayout(new BorderLayout());

            guiFrame.add(GetTitlePanel(), BorderLayout.NORTH);

            // Content panel setup
            final JPanel contentPanel = new JPanel();
            contentPanel.setLayout(new GridLayout(1, 2));
            contentPanel.setBorder(new EmptyBorder(10, 10, 10, 10));
            guiFrame.add(contentPanel, BorderLayout.CENTER);

            // Request panel setup
            final JPanel reqPanel = new JPanel();
            reqPanel.setLayout(new BoxLayout(reqPanel, BoxLayout.Y_AXIS));
            reqPanel.setBorder(BorderFactory.createTitledBorder(
                    BorderFactory.createEtchedBorder(), "Wall Requirements"));

            JScrollPane reqScrollPane = new JScrollPane(reqPanel);
            reqScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
            contentPanel.add(reqScrollPane);

            
            
            // Results panel setup
            final JPanel resultPanel = new JPanel();
            resultPanel.setLayout(new BoxLayout(resultPanel, BoxLayout.Y_AXIS));
            resultPanel.setBorder(BorderFactory.createTitledBorder(
                    BorderFactory.createEtchedBorder(), "Results"));
            contentPanel.add(resultPanel);

            // JList for displaying results
            final JList<String> wallList = new JList<>(model);
            JScrollPane wallScrollPanel = new JScrollPane(wallList);
            wallScrollPanel.setBorder(BorderFactory.createEmptyBorder());
            wallScrollPanel.setSize(new Dimension(100, 50));
//            wallScrollPanel.setMaximumSize(new Dimension(300, 100));
            resultPanel.add(wallScrollPanel);

            // JLabel for displaying selected wall image
            final JLabel wallIcon = new JLabel();
            wallIcon.setHorizontalAlignment(JLabel.CENTER);
            resultPanel.add(wallIcon); // Add the JLabel for the image to the result panel

            // Project Name input
            JLabel nameLbl = new JLabel("Project Name:");
            final JTextField pname = new JTextField(10);
            pname.setFont(new Font("GilSans", Font.PLAIN, 12));
            JPanel pnPanel = new JPanel();
            pnPanel.add(nameLbl);
            pnPanel.add(pname);
            reqPanel.add(pnPanel);

            // Fire Resistance input
            JLabel frLbl = new JLabel("Fire Resistance (in hours):");
            SpinnerModel frModel = new SpinnerNumberModel(0, 0, 10, 0.01);
            final JSpinner frSpinner = new JSpinner(frModel);
            frSpinner.setFont(new Font("GilSans", Font.PLAIN, 12));
            JPanel frPanel = new JPanel();
            frPanel.add(frLbl);
            frPanel.add(frSpinner);
            reqPanel.add(frPanel);

            // Thermal Resistance input
            JLabel trLbl = new JLabel("Thermal Resistance:");
            SpinnerModel trModel = new SpinnerNumberModel(11.5, 0, 60, 0.5);
            final JSpinner trSpinner = new JSpinner(trModel);
            trSpinner.setFont(new Font("GilSans", Font.PLAIN, 12));
            JPanel trPanel = new JPanel();
            trPanel.add(trLbl);
            trPanel.add(trSpinner);
            reqPanel.add(trPanel);

            // Sound Transmission Loss input
            JLabel strLbl = new JLabel("Sound Transmission Loss:");
            SpinnerModel strModel = new SpinnerNumberModel(30, 0, 60, 1);
            final JSpinner strSpinner = new JSpinner(strModel);
            strSpinner.setFont(new Font("GilSans", Font.PLAIN, 12));
            JPanel strPanel = new JPanel();
            strPanel.add(strLbl);
            strPanel.add(strSpinner);
            reqPanel.add(strPanel);

            // Condensation Risk input
            JLabel crLbl = new JLabel("Condensation Risk:");
            String[] riskOptions = {"none", "negligible", "low", "high"};
            final JComboBox<String> crCombo = new JComboBox<>(riskOptions);
            crCombo.setFont(new Font("GilSans", Font.PLAIN, 12));
            JPanel crPanel = new JPanel();
            crPanel.add(crLbl);
            crPanel.add(crCombo);
            reqPanel.add(crPanel);

            // Exterior Material options
            ButtonGroup materialGroup = new ButtonGroup();
            JPanel emPanel = new JPanel(new GridLayout(2, 3, 10, 10));
            emPanel.setBorder(BorderFactory.createTitledBorder(
                    BorderFactory.createEtchedBorder(), "Exterior Material"));

            JRadioButton woodBt = new JRadioButton("Wood", new ImageIcon("images/Wood.png"));
            JRadioButton brickBt = new JRadioButton("Brick", new ImageIcon("images/Brick.png"));
            JRadioButton alBt = new JRadioButton("Aluminum", new ImageIcon("images/Aluminum.png"));
            JRadioButton stBt = new JRadioButton("Steel", new ImageIcon("images/Steel.png"));
            JRadioButton cmBt = new JRadioButton("Cement", new ImageIcon("images/Cement.png"));
            JRadioButton noPrefBt = new JRadioButton("No Preference");

            materialGroup.add(woodBt);
            materialGroup.add(brickBt);
            materialGroup.add(alBt);
            materialGroup.add(stBt);
            materialGroup.add(cmBt);
            materialGroup.add(noPrefBt);

            emPanel.add(woodBt);
            emPanel.add(brickBt);
            emPanel.add(alBt);
            emPanel.add(stBt);
            emPanel.add(cmBt);
            emPanel.add(noPrefBt);
            reqPanel.add(emPanel);

            // Lowest Cost checkbox
            JLabel lcLbl = new JLabel("Lowest Cost:");
            JCheckBox lcCheck = new JCheckBox("yes");
            JPanel lcPanel = new JPanel();
            lcPanel.add(lcLbl);
            lcPanel.add(lcCheck);
            reqPanel.add(lcPanel);

            // Submit button with ActionListener
            JButton submitBt = new JButton("SUBMIT");
            submitBt.setAlignmentX(JComponent.CENTER_ALIGNMENT);
            submitBt.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent event) {
                    try {
                        // Clear previous results in model and selectedWall
                        model.clear();
                        selectedWall.clear();

                        // Retrieve values from the form
                        String pn = pname.getText();
                        float fr = ((Number) frSpinner.getValue()).floatValue();
                        float tr = ((Number) trSpinner.getValue()).floatValue();
                        int str = ((Number) strSpinner.getValue()).intValue();
                        String cr = crCombo.getSelectedItem().toString();

                        String exteriorMaterial = "";
                        if (woodBt.isSelected()) exteriorMaterial = "Wood";
                        else if (brickBt.isSelected()) exteriorMaterial = "Brick";
                        else if (alBt.isSelected()) exteriorMaterial = "Aluminum";
                        else if (stBt.isSelected()) exteriorMaterial = "Steel";
                        else if (cmBt.isSelected()) exteriorMaterial = "Cement";
                        else if (noPrefBt.isSelected()) exteriorMaterial = "No Preference";

                        boolean lowestCost = lcCheck.isSelected();

                        // Create and set Fact for Jess
                        Fact input = new Fact("wall-requirements", engine);
                        input.setSlotValue("project-name", new Value(pn, RU.STRING));
                        input.setSlotValue("fire-resistance", new Value(fr, RU.FLOAT));
                        input.setSlotValue("thermal-resistance", new Value(tr, RU.FLOAT));
                        input.setSlotValue("sound-transmission-loss", new Value(str, RU.INTEGER));
                        input.setSlotValue("condensation-risk", new Value(cr, RU.SYMBOL));
                        input.setSlotValue("exterior-material", new Value(exteriorMaterial, RU.SYMBOL));
                        input.setSlotValue("best", new Value(lowestCost ? "yes" : "no", RU.SYMBOL));

                        // Assert the Fact and run Jess engine
                        engine.assertFact(input);
                        engine.run();

                        // Retrieve facts from Jess and update model and selectedWall
                        Iterator<?> it = engine.listFacts();
                        while (it.hasNext()) {
                            Fact fact = (Fact) it.next();
                            if (fact.getName().contains("wall-selection")) {
                                String id = fact.getSlotValue("id").toString();
                                String cost = fact.getSlotValue("cost").toString();
                                String best = fact.getSlotValue("best").toString();
                                model.addElement("Wall: " + id + " Cost: " + cost + " Lowest Cost: " + best);

                                
                                String imagePath = "images/wall/"+id+".png";  // Adjust the path if necessary
                                selectedWall.add(imagePath);

                                System.out.println("Added image path to selectedWall: " + imagePath);
                            }
                        }
                    } catch (JessException ex) {
                        ex.printStackTrace();
                    }
                }
            });
            reqPanel.add(submitBt);

            // Listener for selecting an item in JList to show image
            wallList.addListSelectionListener(new ListSelectionListener() {
                public void valueChanged(ListSelectionEvent arg0) {
                    if (!arg0.getValueIsAdjusting()) {
                        int i = wallList.getSelectedIndex();
                        if (i >= 0 && i < selectedWall.size()) { // Check if the index is valid
                            wallIcon.setIcon(new ImageIcon(((new ImageIcon(
                                    selectedWall.get(i)).getImage()
                                    .getScaledInstance(100, 100, java.awt.Image.SCALE_SMOOTH)))));
                            
                        }
                    }
                }
            });

            // Finalize GUI setup
            guiFrame.setVisible(true);

        } catch (JessException ex) {
            ex.printStackTrace();
        }
    }

    // Helper method to create title panel
    static JPanel GetTitlePanel() {
        JPanel titlePanel = new JPanel();
        JLabel titleLabel = new JLabel("WALL SELECTION");
        titlePanel.setBackground(Color.WHITE);
        titleLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 18));
        titlePanel.add(titleLabel);
        return titlePanel;
    }
}
