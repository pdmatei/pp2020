import java.util.Iterator;

/* first of all, let us recall the interface Iterator:

	interface Iterator<T> {
		public boolean hasNext();
		public T next();
	}

   the aim of this implementation is to TRAVERSE a sequence, instead
   of simply creating another one from scratch.

   in OOP, traversals are realised by iterators, and each collection
   which can be traversed implements:

   interface Iterable<T> {
		public Iterator<T> interator();
   }

   unfortunately, each collection has a UNIQUE iterator, and for lists
   we would like to have different iterators

   we can achieve this by implementing a "view".

   Suppose we have a DS (DataStructure):
   		DS
   		View1 View2 ... Viewn

   each view has "a copy" (or reference to) the DS itself
   each view implements a different traversal strategy, hence it is an iterable

   We choose the simplest DS possible:
   Integer[] v = new Integer[] {1,2,3};

   And create a new view, which we will implement later;
   RList<Integer> r = new RList(v);

   Then use this view, to traverse the DS (in reverse):

   Iterator<Integer> rev = r.iterator();
		while(r.hasNext()){
			r.next();
		}

	Now, all we have to do is implement the RList view, 
	and more importantly, it's iterator;

   
   What we have achieved is multiple traversals of the same DS, using multiple
   views. The traversal of the DS is not separated from the DS implementation,
   but this was not an objective. Since traversals are important here, (and not an
   altered DS, as in the previous example), views (and their iterators) achieve this
   level of abstractisation.

   It may make more sense to write:
   Iterator<Integer> reverse = new RList(...).iterator();

   Traversals are important parts of OO and Concurrent programming, and a key aspect of
   ensuring DS synchronisation.

*/

class RList<T> implements Iterable<T>{
	private T[] array;

	public RList(T[] array){
		this.array = array;
	}

	@Override
	public Iterator<T> iterator(){
		return new Iterator<T>(){
			private int crtIndex = array.length - 1;

			@Override
			public boolean hasNext() {
				return crtIndex >= 0;
			}

			@Override
			public T next(){
				return array[crtIndex--];
			}

			@Override
			public void remove(){} //nimic
		};
	}
}

public class V3 {

	

	public static void main (String[] args){
		Integer[] v = new Integer[] {1,2,3};
		RList<Integer> r = new RList(v);

		Iterator<Integer> rev = r.iterator();
		while(rev.hasNext()){
			System.out.println(rev.next());
		}

	}
}