/*
	returning to our previous TDA example, we can take it one step further
	and express reversal as a particular of a more general list operation.

	Let us find out what that operation is. Suppose we have a list of integers,
	we extract the first, add it to an initial value, and recursively repeat the process:

	[1,2,3]

    [2,3]  1 + 0
    [3]    2 + 1 + 0
    []     3 + 2 + 1 + 0

    now, instead of '+', let us put an abstract operation, and instead of 0, an accumulator

		   3 op 2 op 1 op acc
    
    we can easily see that if we replace op with 'cons' and acc with the empty list, we get reverse

    Let us write axioms for sum:

	sum [] = 0
    sum (x:xs) = x + sum(xs)

    In the same way, we can write axioms for our generalised folding operation.
    Folding depends on two things, the operator op, and the initial value acc, apart from
    the list itself

    fold(op,acc,[]) = acc
    fold(op,acc,(x:xs)) = op(x,fold(op,acc,xs))

    Now, putting this into Java requires several steps.
*/

interface Op <A,B> {
	public B call (A a, B b);
}

interface Foldable <A> {
	public <B> B fold (Op<A,B> op, B acc);
}

/* careful: Foldable is required on when calling next.fold(...) so 
            lists must be foldable, not just their implementation */

interface List<T> extends Foldable<T>{
	public T head ();
	public List<T> tail ();
}

/* careful - the type parameter A is bound to the inner type, while B is bound to the fold */
class Cons<T> implements List<T>{
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

	@Override
	public <B> B fold (Op<T,B> op, B acc){
		//fold(op,acc,(x:xs)) = op(x,fold(op,acc,xs))
		return op.call(val,next.fold(op,acc));
	}
}

class Empty<T> implements List<T> {
	@Override
	public T head() {return null;}
	@Override
	public List<T> tail() {return null;}
	@Override
	public <B> B fold (Op<T,B> op, B acc){
		return acc;
	}
}

public class V4 {

	public static void main (String[] args){
		
		List<Integer> v = new Cons(1, new Cons(2, new Cons(3, new Empty())));
		List<Integer> r = v.fold(new Op<Integer,List<Integer>>(){
				@Override
				public List<Integer> call (Integer i, List<Integer> l){
					return new Cons(i,l);
				}
		},new Empty());
	}
}

