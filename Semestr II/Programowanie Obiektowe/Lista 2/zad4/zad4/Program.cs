//Michał Bronikowski 292227
// zad 4 lista 2
using System.Collections.Generic;
using System;


	class ListaLeniwa
	{
		public int rozmiar;
		public List<int> Lista;
		public Random rand;

		protected virtual int nastepna(int k)
		{
			return rand.Next ();
		}
		

		public int liczba(int k)
		{
			if (k < rozmiar) return Lista [k];
			else
			{
				rozmiar = k;

				if (Lista.Count == 0) Lista.Add (0);

				for(int i = Lista.Count-1; i < k; i++)
				{
					Lista.Add(nastepna(Lista[i]));
				}

				return Lista [k];
			}
		}

		public int size()
		{
			return rozmiar;
		}

		public ListaLeniwa()
		{
			rozmiar = 0;
			Lista = new List<int>();
			rand = new Random ();
		}
		
	}

class Pierwsze : ListaLeniwa
{
	private bool pierwsza(int k)
	{
		if (k < 2)
		{
			return false;
		}

		for (int i = 2; i <= Math.Sqrt(k); ++i)
		{
			if (k % i != 0) return true;
		}

		return true;
	}

	override protected int nastepna(int k)
	{
		k = k + 1;
		while (!pierwsza (k)) k = k + 1;
		return k;
	}
}

class Zadanie4
{
	public static void Main ()
	{
		ListaLeniwa lista = new ListaLeniwa();
		Pierwsze lista2 = new Pierwsze ();
		Console.WriteLine(lista.liczba(40));
		Console.WriteLine ("Romiar listy: {0}",lista.size ());
		Console.WriteLine(lista.liczba(38));
		Console.WriteLine ("Romiar listy: {0}",lista.size ());
		Console.WriteLine(lista.liczba(42));
		Console.WriteLine ("Romiar listy: {0}",lista.size ());
		Console.WriteLine ("Lista dla pierwszych");
		Console.WriteLine(lista2.liczba(1));
		Console.WriteLine ("Romiar listy: {0}",lista2.size ());
		Console.WriteLine(lista2.liczba(2));
		Console.WriteLine ("Romiar listy: {0}",lista2.size ());
		Console.WriteLine(lista2.liczba(50));
		Console.WriteLine ("Romiar listy: {0}",lista2.size ());
	}
}