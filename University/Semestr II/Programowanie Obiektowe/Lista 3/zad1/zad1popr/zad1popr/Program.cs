using System;

public class List<T>
{
	private class wezel
	{
		public wezel Nast;
		public wezel Poprz;
		public T Value;
	}
	private wezel glowa;
	private wezel AktualnyWezel;
	private int IloscElementowWLiscie;


	public List()
	{
		glowa = new wezel();
		AktualnyWezel = glowa;
	}


	public void DodajNaKoniec(T info)
	{
		wezel newwezel = new wezel();
		newwezel.Value = info;
		AktualnyWezel.Nast = newwezel;
		newwezel.Poprz = AktualnyWezel;
		AktualnyWezel = newwezel;
		IloscElementowWLiscie++;
	}

	public void DodajNaPoczatku(T info)
	{
		wezel newwezel = new wezel() { Value = info};
		newwezel.Nast = glowa.Nast;
		glowa.Nast.Poprz = newwezel;
		glowa.Nast = newwezel;
		IloscElementowWLiscie++;
	}

	public void UsunZpoczatku()
	{
		if (IloscElementowWLiscie > 0)
		{
			glowa.Nast = glowa.Nast.Nast;
			glowa.Nast.Poprz = glowa;
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
			AktualnyWezel.Poprz.Nast = null;
			AktualnyWezel = AktualnyWezel.Poprz;
			AktualnyWezel.Nast = null;
			IloscElementowWLiscie--;
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
		List<string> MojaLista = new List<string>();
		if (MojaLista.CzyPusta ())
			Console.WriteLine ("Lista jest pusta");

		MojaLista.WypiszListe();

		MojaLista.DodajNaKoniec ("12");
		MojaLista.DodajNaKoniec("cos tam");
		MojaLista.DodajNaKoniec ("2432523");
		MojaLista.DodajNaKoniec ("3.14");
		MojaLista.WypiszListe();

		if (MojaLista.CzyPusta ())
			Console.WriteLine ("Lista jest pusta");

		MojaLista.DodajNaPoczatku("55");
		MojaLista.WypiszListe();


		MojaLista.UsunZpoczatku();
		MojaLista.WypiszListe();

		MojaLista.UsunZKonca ();
		MojaLista.WypiszListe ();

	}
}




























