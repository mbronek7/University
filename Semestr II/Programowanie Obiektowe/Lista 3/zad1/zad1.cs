using System;

class zad1
{
	static void Main(string[] args)
	{           
		List MojaLista = new List();
		if (MojaLista.CzyPusta ())
			Console.WriteLine ("Lista jest pusta");
		
		MojaLista.WypiszListe();

		MojaLista.DodajNaKoniec(12);
		MojaLista.DodajNaKoniec("cos tam");
		MojaLista.DodajNaKoniec(12432523);
		MojaLista.DodajNaKoniec(3.14);
		MojaLista.WypiszListe();

		if (MojaLista.CzyPusta ())
			Console.WriteLine ("Lista jest pusta");

		MojaLista.DodajNaPoczatku(55);
		MojaLista.WypiszListe();
	

		MojaLista.UsunZpoczatku();
		MojaLista.WypiszListe();

		MojaLista.UsunZKonca ();
		MojaLista.WypiszListe ();

	}
}
