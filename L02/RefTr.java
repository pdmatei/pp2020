/* 
	Side effects can be dangerous for programmers;
*/

public class RefTr {
	
	public static int m = 0;

	static int f (int x){
		return x + (++m);
	}

	static int g (int x){
		return x + m + 1;
	}


	public static void main (String[] args){
	
	}

}























/*

		System.out.println(g(1)==f(1));
		// replace by System.out.println(f(1)==g(1));

		// also:
		System.out.println(f(1)==f(1));

		//also:
		if (g(1)==f(1)){
			System.out.println(f(1) - g(1));
		}
*/


