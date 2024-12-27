package Part1;

import jess.*;


public class Part1 {

    public static void main(String[] args) {
        try {
            // Initialize Jess rule engine
            Rete engine = new Rete();
            engine.reset();
            System.out.println("Mahsa Aghazadeh 20234622 Part 1\n");
            // Load rule files\
            engine.batch("src/Part1/temps.clp");
            engine.batch("src/Part1/data.clp");
            engine.batch("src/Part1/rules.clp");

            engine.eval("(run)");


        } catch (JessException ex) {
            ex.printStackTrace();
        }
    }
}
//
//
//Mahsa Aghazadeh 20234622 Part 1
//
//personal-exemptions: 1000
//NUMBER-OF-EXEMPTIONS: 1
//adjustments-to-income: 6000
//BUSINESS-EXPENSES: 2000
//ALIMONY: 1000
//IRA-CONTRIBUTIONS: 3000
//deduction: 2200
//itemized-deductions: 4500
//CHARITABLE-CONTRIBUTIONS: 500
//MORTGAGE-INTEREST-DEDUCTION: 2500
//PROPERTY-TAXES: 1500
//net-taxable-income: 43800
//gross-taxable-income: 44800
//adjusted-gross-income: 47000
//total-taxable-income: 53000
//INVESTMENT-INCOME: 8000
//EARNINGS: 45000
