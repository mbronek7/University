import java.io.*;
import java.util.Collection;
import java.util.EmptyStackException;

class Data<T> implements Serializable
{
	T val = null; // wartosc wezla
	Data <T> next = null;//wskaznik na nastepny element
	Data <T> prev = null;//wskaznik na element poprzedni

	Data(){ // konstruktor pusty
	}
	Data(T val){ // konstruktor z wartoscia
		this.val = val;
	}
	
	private void writeObject( ObjectOutputStream out) //zapisuje na wyjsciu
			throws IOException
	{
		out.defaultWriteObject();
	}
	private void readObject(ObjectInputStream in) // czytam z wejscia
			throws IOException, ClassNotFoundException
	{
		in.defaultReadObject();
	}

}


class List<T> implements Serializable
/*
Serializacja to wbudowany mechanizm zapisywania obiektów, który pozwala na binarny zapis całego drzewa obiektów. Oznacza to tyle, że jeśli mamy obiekt X, który posiada referencję do obiektu Y to serializując X również Y zostanie automatycznie zapisany w strumieniu wyjściowym. - See more at: http://www.samouczekprogramisty.pl/serializacja-w-jezyku-java/#sthash.ez6aljwi.dpuf
*/

{
	Data<T> begin;
	Data<T> end;
	protected T val;

	public List(){
		begin = end = null;
	}
	public List(T init){
		begin = end = new Data<T> (init);
		val = init;
	}

	public void pushTop(T elem){
		if (this.isEmpty ())
			end = begin = new Data<T> (elem);
		
		else {
			this.begin.prev = new Data<T> (elem);
			this.begin.prev.next = this.begin;
			this.begin = this.begin.prev;
		}
	}

	public void pushEnd(T elem){
		if(this.isEmpty()){
			end = begin = new Data<T> (elem);
		}else{
			this.end.next = new Data<T> (elem);
			this.end.next.prev = this.end;
			this.end = this.end.next;
		}
	}

	public T popTop() throws EmptyStackException
	{
		if (isEmpty ()) // jesli stos jest pusty
			throw new EmptyStackException();
			

		T ret = begin.val;

		if(begin == end){
			begin = end = null;
		}else{
			begin = begin.next;
			begin.prev.next = null;
			begin.prev = null;
		}
		return ret;
	}

	public T popEnd()throws EmptyStackException
	{
		if (isEmpty ()){
			throw new EmptyStackException();
			//return val;
		}				
		
		T ret = end.val;
		
		if(begin == end){
			begin = end = null;
		}else{
			end = end.prev;
			end.next.prev = null;
			end.next = null;
		}
		return ret;
	}
		
	public boolean isEmpty(){
		return this.begin == null && this.end == null;
	}
		
	private void writeObject( ObjectOutputStream out) 
			throws IOException
	{
		out.defaultWriteObject();
	}
	private void readObject(ObjectInputStream in) 
			throws IOException, ClassNotFoundException
	{
		in.defaultReadObject();
	}

}

public class zad1
{
	public static void main(String[] args)
	{
		List<Integer> List = new List<Integer> ();

		
		try{
			System.out.println ("CZy pusta jest pusta? " + List.isEmpty());
			List.pushEnd (1);
			List.pushEnd (2);
			System.out.println ("Czy po dodaniu pusta? " + List.isEmpty());
			System.out.println("usuwam " + List.popEnd ());
			System.out.println("usuwam " + List.popEnd ());
			System.out.println ("Czy nadal pusta?  " + List.isEmpty());
			System.out.println ("Czy nadal pusta?  " + List.isEmpty());
	
			List.pushTop (3);
			System.out.println ("Czy pusta po dodaniu?  " + List.isEmpty());
			System.out.println("usuwam  " + List.popTop ());
			System.out.println ("Czy pusta?  " + List.isEmpty());
	
			List.pushTop (1);
			List.pushTop (2);
			List.pushEnd (3);
			List.pushEnd (4);
	
			
			System.out.println ("\nCzy pusta?  " + List.isEmpty());	
		}
		catch(EmptyStackException e){ // czy pusty rzucam wyjatkiem
			System.out.println(e);
		}
		
		System.out.println ("\nA teraz dane zapisujemy i odczytujemy z pliku");	
		// PLIK 
		List<String> toWrite = new List<String> ();
		toWrite.pushEnd("kasia");
		toWrite.pushEnd("asia");
		toWrite.pushEnd("alicja");
		toWrite.pushEnd("zofia");
		
		try
        {
            FileOutputStream file =
                    new FileOutputStream("genByZad1Lista6.txt");
            ObjectOutputStream strOut = new ObjectOutputStream(file);
            strOut.writeObject(toWrite); // zapisuje do piku
            strOut.close(); 
            file.close();// zamykam wyjscie
        }catch(IOException e)// wyjatek do bledu obslugi plikow
        {
            e.printStackTrace();
        }
        
		List<String> read = null;
        try
        {
            FileInputStream file = new FileInputStream("genByZad1Lista6.txt");
            ObjectInputStream strIn = new ObjectInputStream(file);
            read = (List) strIn.readObject();
            strIn.close();
            file.close();
        }catch(IOException e)
        {
            e.printStackTrace();//StackTrace to “ścieżka”, którą podążało wykonanie programu do momentu powstania błędu.
            return;
        }catch(ClassNotFoundException e)
        {
            e.printStackTrace();//StackTrace to “ścieżka”, którą podążało wykonanie programu do momentu powstania błędu.
            return;
        }
        
        System.out.println(read.popEnd());
        System.out.println(read.popEnd());
        System.out.println(read.popEnd());
				
	}
}
