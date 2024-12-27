/* The requires directives in module-info.java are used to explicitly 
 * declare the dependencies of your module.   */
module Homework1 {
	// access to Java classes for building a graphical user interface (GUI)
	requires java.desktop; 
	// access to the Jess rule engine for creating rule-based systems
	requires jess;
}

