import java.util.Hashtable;
import java.util.*;

 abstract class Wyrazenie //klasa abstrakcyjna klasa dziedziczaca okresla cialo metod tu jest tylko jej deklaracja
{
	public abstract int oblicz();
	public abstract String toString();
}

 class Stala extends Wyrazenie 
{
	public int val;
	
	public Stala(int val) //konstruktor 
	{
		this.val = val;
	}
	
	public int oblicz()//dla stalej po prostu zwracam wartosc
	{
		return this.val;
	}
	
	public String toString()
	{
		return  "" + val;
	}

}

class Zmienna extends Wyrazenie 
{
	public String zmienna;
	public Hashtable<String, Integer> wezel; //mapa kluczem jest string a wartoscia integer
	
	public Zmienna(String SymbolZmiennej, Hashtable<String, Integer> KluczwMapie)
	{
		this.zmienna = SymbolZmiennej;
		this.wezel = KluczwMapie;
	}

	public int oblicz() 
	{
		return wezel.get(zmienna);
	}
	
	public String toString()
	{
		return "" + zmienna;	
	}

}

 class Operacja extends Wyrazenie
{
	public Wyrazenie PoLewej;
	public Wyrazenie PoPrawej;
	public char operator;
	
	public Operacja(Wyrazenie PoLewej, Wyrazenie PoPrawej, char operator)//konstruktor ustawiam sobie wartosci
	{
		this.PoLewej = PoLewej; //this jest bo odwoluje sie do tych wyzej
		this.PoPrawej = PoPrawej;
		this.operator = operator;
	}

	public int oblicz()
	{
		switch(operator){
			case('+'):
			{
				return PoLewej.oblicz() + PoPrawej.oblicz();
			}
			case('-'):
			{
				return PoLewej.oblicz() - PoPrawej.oblicz();	
			}
			case('/'):
			{
				return PoLewej.oblicz() / PoPrawej.oblicz();
			}
			case('*'):
			{
				return PoLewej.oblicz() * PoPrawej.oblicz();
			}
			default:
			{
			return 0;
			}
		}
		
	}

	public String toString()
	{
		return "(" + PoLewej + " " + operator + " " + PoPrawej + ")";
	}

}


public class Main 
{
	public static void main (String[] args)
	{
		Hashtable <String, Integer> tree = new Hashtable <String, Integer>();
		tree.put("x", 12);
		System.out.println("x = " + tree.get("x"));
		Wyrazenie wyrazenie = new Operacja (new Stala(20), new Zmienna("x", tree), '-');
		System.out.println(wyrazenie.toString() + " = " + wyrazenie.oblicz());
		tree.put("y", 123);
		tree.put("x", 0);
		System.out.println("y = " + tree.get("y"));
		wyrazenie = new Operacja(wyrazenie, new Stala(2), '+');
		System.out.println(wyrazenie.toString() + " = " + wyrazenie.oblicz());
		wyrazenie = new Operacja(wyrazenie, new Zmienna("y", tree), '*');
		System.out.println(wyrazenie.toString() + " = " + wyrazenie.oblicz());
		wyrazenie = new Operacja(wyrazenie, new Stala(10), '/');
		System.out.println(wyrazenie.toString() + " = " + wyrazenie.oblicz());
		
	}
}
