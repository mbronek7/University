//Michał Bronikowski 292227
using System;
using System.Text;
using System.Linq;
using System.Threading;
using System.Collections.Generic;

	class IntStream 
	{
		public int aktualna_wartosc;

		public IntStream()
		{
		aktualna_wartosc = -1;
		}

		public int next()
		{
		aktualna_wartosc++;
		return aktualna_wartosc;
		}
		public void reset()
		{
		aktualna_wartosc = -1;
		}
		public bool eos()
		{
		if (aktualna_wartosc < Int32.MaxValue) 
			return false;
			return true;
		}
		
	}

	class PrimeStream : IntStream
	{
		public int pierwsza;
		public PrimeStream()
		{
		pierwsza = 2;
		}

		public int next()
		{
		int rez = pierwsza;
			int j;

		for (int i = pierwsza+1; i < Int32.MaxValue; i++)
			{
				int licznik = 0;
			    for (j = 2; j < i+2; ++j)
				   if (i % j == 0 && i != j) licznik++;

				if (licznik < 1) 
				{
				pierwsza = i; 
				break; 
				}
			}

			return rez;
		}
	}

	class RandomStream : IntStream
	{
	    public int losowa;
		public RandomStream()
		{
			 losowa= 2;
		}

		public int next()
	{
			System.Random Totolotek = new  Random(Guid.NewGuid().GetHashCode());
			int rez = Totolotek.Next(1, Int32.MaxValue);
		    losowa = rez;
			return losowa;
		}
	}

	class RandomWorldStream : PrimeStream
	{
		
		public string nextL()
		{
			int ile= pierwsza;
			base.next();
	    	char[] litery={'a','b','c','d','e','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
		    Random r = new Random(Guid.NewGuid().GetHashCode());
			string rez = "";
			for (int i = 0; i < ile; ++i)
			{
				int random_litera = r.Next(litery.Length);
				rez = rez + litery[random_litera].ToString();
			}
			return rez;
		}
	}



	class MAIN
	{
		static void Main()
		{
		IntStream strumNaturalny = new IntStream();
		PrimeStream strumPierwszych = new PrimeStream();
		RandomStream strumRandomowych = new RandomStream();
		RandomWorldStream strumRandomowychStringow = new RandomWorldStream();
		Console.Write("Kolejna liczba naturalna: {0} \n", strumNaturalny.next());
		Console.Write("Kolejna liczba naturalna: {0} \n", strumNaturalny.next());
		Console.Write("Kolejna liczba naturalna: {0} \n", strumNaturalny.next());
		Console.Write("Reset strumienia.\n");
		strumNaturalny.reset();
		Console.Write("Kolejna liczba naturalna: {0} \n", strumNaturalny.next());
		Console.Write("Kolejna liczba naturalna: {0} \n", strumNaturalny.next());
		if (strumNaturalny.eos() == false) Console.Write("\tStan eos: falsz.\n");
		else Console.Write("\tStan eos: prawda.\n");
		Console.Write("Kolejna liczba pierwsza: {0} \n", strumPierwszych.next());
		Console.Write("Kolejna liczba pierwsza: {0} \n", strumPierwszych.next());
		Console.Write("Kolejna liczba pierwsza: {0} \n", strumPierwszych.next());
		Console.Write ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
		Console.WriteLine("Kolejna liczba losowa: {0} ",strumRandomowych.next());
		Console.WriteLine("Kolejna liczba losowa: {0}",strumRandomowych.next());
		Console.WriteLine("Kolejna liczba losowa: {0} ",strumRandomowych.next());
		Console.Write ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
		Console.Write("Kolejny losowy string: {0}\n", strumRandomowychStringow.nextL());
		Console.Write("Kolejny losowy string: {0}\n", strumRandomowychStringow.nextL());
		Console.Write("Kolejny losowy string: {0}\n", strumRandomowychStringow.nextL());
		}
	}

