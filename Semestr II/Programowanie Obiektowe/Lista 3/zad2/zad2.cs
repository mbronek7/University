using System;

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
