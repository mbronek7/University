using System;
using System.Collections.Generic;

class Slownik<K,V>
{
	private class rekord
	{
		public rekord Nast;
		public V Value;
		public K Key;
	}

	public bool Compare<K>(K x, K y)
	{
		return EqualityComparer<K>.Default.Equals(x, y);
	}

	private rekord glowa;
	private rekord AktualnyRekord;

	public Slownik()
	{
		glowa = new rekord();
		AktualnyRekord = glowa;
	}

	public void Dodaj(K Klucz,V wartosc)
	{

		rekord teraz = glowa;
		while (teraz.Nast != null)
		{
			teraz = teraz.Nast;
			if (Compare (Klucz, teraz.Key)) {
				Console.WriteLine ("Błąd : W słowniku już jest rekord o podanym kluczu");
				return;
			}

		}

		rekord newrekord = new rekord();
		newrekord.Value = wartosc;
		newrekord.Key = Klucz;
		AktualnyRekord.Nast = newrekord;
		AktualnyRekord = newrekord;
	}

	public void Usun(K Klucz)
	{

		rekord teraz = glowa,x;
		while (teraz.Nast != null)
		{
			x = teraz.Nast;
			if (Compare(x.Key,Klucz))
			{
				if (!(Compare (Klucz,glowa.Nast.Key)))
				{
					teraz.Nast = x.Nast;
					break;
				} 
				else {
					glowa = new rekord ();
					AktualnyRekord = glowa;
					break;
				}
			}
			teraz = teraz.Nast;

		}
	}
	public bool Wyszukaj (K Klucz)
	{
		rekord teraz = glowa;
		while (teraz.Nast != null)
		{
			teraz = teraz.Nast;
			if (Compare(teraz.Key,Klucz))
			{
				Console.WriteLine ("W słowniku jest hasło o rekordzie: {0},to hasło to: {1}",Klucz,teraz.Value);
				return true;
			}


		}
		return false;
	}
	public void Wypisz()
	{

		rekord teraz = glowa;
		while (teraz.Nast != null)
		{
			teraz = teraz.Nast;
			Console.WriteLine("Klucz : {0}, Hasło: {1}",teraz.Key,teraz.Value);

		}
		Console.Write("Koniec\n");
	}
}
class Zad2
{
	public static void Main (string[] args)
	{
		Slownik<int,string> nowy = new Slownik<int,string> ();
		nowy.Dodaj (2, "ala");
		nowy.Dodaj (2, "ala2");
		nowy.Wypisz ();
		Console.WriteLine ("Po usuniecie rekordu nr: 2");
		nowy.Usun (2);
		nowy.Wypisz ();
		nowy.Dodaj (1, "maja");
		nowy.Dodaj (3, "kaja");
		nowy.Dodaj (4, "franka");
		nowy.Wypisz ();
		if (nowy.Wyszukaj (4))
			Console.WriteLine ("Sukces");


	}


}