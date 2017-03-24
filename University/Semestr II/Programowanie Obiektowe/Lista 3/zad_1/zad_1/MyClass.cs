using System;



public class List
{
	public class wezel
	{
		public wezel Nast;
		public object Value;
	}
	private wezel glowa;
	private wezel AktualnyWezel;
	private int IloscElementowWLiscie;


	public List()
	{
		glowa = new wezel();
		AktualnyWezel = glowa;
	}


	public void DodajNaKoniec(object info)
	{
		wezel newwezel = new wezel();
		newwezel.Value = info;
		AktualnyWezel.Nast = newwezel;
		AktualnyWezel = newwezel;
		IloscElementowWLiscie++;
	}

	public void DodajNaPoczatku(object info)
	{
		wezel newwezel = new wezel() { Value = info};
		newwezel.Nast = glowa.Nast;
		glowa.Nast = newwezel;
		IloscElementowWLiscie++;
	}

	public void UsunZpoczatku()
	{
		if (IloscElementowWLiscie > 0)
		{
			glowa.Nast = glowa.Nast.Nast;
			IloscElementowWLiscie--;
		}
		else
		{
			Console.WriteLine("Lista jest Pusta");
		}
	}
	public void UsunZKonca()
	{
		if (IloscElementowWLiscie > 0)
		{
			wezel teraz = glowa;
			while (teraz.Nast != AktualnyWezel) {
				teraz = teraz.Nast;
			}
			teraz.Nast = null;
		} 
		else 
		{
			Console.WriteLine("Lista jest Pusta");
		}
	}

	public bool CzyPusta()
	{
		if (IloscElementowWLiscie == 0)
			return true;
		return false;
	}

	public void WypiszListe()
	{
		Console.Write("glowa -> ");
		wezel teraz = glowa;
		while (teraz.Nast != null)
		{
			teraz = teraz.Nast;
			Console.Write(teraz.Value);
			Console.Write(" -> ");
		}
		Console.Write("Koniec\n");
	}
}
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