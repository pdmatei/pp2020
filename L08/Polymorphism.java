interface Living {
	public String breathe ();
	/*
        each class will provide with a specific implementation for breathe
	*/
}

class Animal extends Living {
	public String scream (){
		return "An animal screams !";
	}
	@Override 
	public String breathe () {
		return "An animal breathes ";
	}
}

class Wolf extends Animal {
	/* this method is a specialization of the former */

	@Override
	public String scream(){
		return "Bark "+super.scream();
	}

	@Override 
	public String breathe () {
		return "A wolf breathes ";
	}
}




