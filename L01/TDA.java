/*
	objective:
	separate the "algorithm" from the data-structure
	avoid in-place reversal (original list is lost)
*/


interface List<T> {
	public T head ();
	public List<T> tail ();
}

class Cons<T> implements List<T> {
	T val;
	List<T> next;
	public Cons (T val, List next){
		this.val = val;
		this.next = next;
	}
	@Override
	public T head() {return val;}
	@Override
	public List<T> tail() {return next;}
}

class Empty<T> implements List<T> {
	@Override
	public T head() {return null;}
	@Override
	public List<T> tail() {return null;}
}



public class TDA {

	private static <T> List<T> rev (List<T> x, List<T> y){
		if (x instanceof Empty)
			return y;
		return rev(x.tail(), new Cons(x.head(),y));
	}

	public static <T> List<T> reverse (List l){
		return rev(l,new Empty());
	}

	public static void main (String[] args){
		List<Integer> v = new Cons(1, new Cons(2, new Cons(3, new Empty())));
		List<Integer> r = reverse(v);
	}
	
}