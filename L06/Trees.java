import java.util.*;

interface Tree<E> {
	public Integer size();
	public Tree<E> mirror();	
	public List<E> flatten();
	public <F> Tree<F> map(Function<E,F> f);
}

interface Function<E,F> {
	public F call (E e);
}

class Void<E> implements Tree<E> {
	@Override
	public Integer size() {return 0;}
	@Override 
	public Tree<E> mirror () {return new Void<E>();}
	@Override
	public List<E> flatten(){return new LinkedList();}
	@Override 
	public <F> Tree<F> map(Function<E,F> f){return new Void<F>();}
	@Override
	public String toString() {return "{}";}
}

class Node<E> implements Tree<E> {
	private Tree<E> l,r;
	private E k;
	public Node (Tree<E> l, E k, Tree<E> r){
		this.l = l;
		this.k = k;
		this.r = r;
	}
	@Override
	public Integer size() {return 1 + l.size() + r.size();}
	@Override 
	public Tree<E> mirror () {return new Node<E>(l.mirror(),k,r.mirror());}
	@Override
	public List<E> flatten(){ 
		List<E> ls = l.flatten(); 
		ls.add(k);
		ls.addAll(r.flatten());
		return ls;
	}
	@Override 
	public <F> Tree<F> map(Function<E,F> f){return new Node<F>(l.map(f),f.call(k),r.map(f));}

	@Override
	public String toString() {
		return "{"+l.toString()+","+k.toString()+","+r.toString()+"}";}
}


public class Trees {
	public static void main (String[] args){
		Tree<Integer> t = new Node<Integer>(
					new Node<Integer>(new Node<Integer> (new Void<Integer>(),1,new Void<Integer>()),
						  2,new Node<Integer>(new Void<Integer>(),4,new Void<Integer>()))
					,3,new Node<Integer>(new Void<Integer>(),0,new Void<Integer>()));
		System.out.println(t.mirror());

		System.out.println(t.map(new Function<Integer,Boolean>(){
			public Boolean call (Integer i) {return i % 2 == 0;}
		}));
	}
}