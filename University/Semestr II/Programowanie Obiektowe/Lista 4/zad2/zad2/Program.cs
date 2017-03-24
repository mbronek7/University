﻿using System;
using System.Collections;

namespace zad2
{
	public class PrimeCollection : IEnumerator// interfejs Obsługuje proste iteracji w kolekcji-uniwersalne.
	{
		protected int Current;

		private bool IsPrime(int number)
		{
			if (number < 2) 
				return false;
			if (number == 2)
				return true;
			for (int i = 3; i < Math.Sqrt(number + 1); ++i)
			{
				if (number % i == 0) 
					return false;
			}

			return true;
		}
		public bool MoveNext()
		{
			Current++;
			while (IsPrime(Current) == false) 
				Current++;
			if (Current == Int32.MaxValue)
				return false;
			return true;
		
		}

		public PrimeCollection()
		{
			Current = 0;
		}

		object IEnumerator.Current
		{
			get 
			{
				return Current;
			}
		}

		public void Reset()
		{
			Current = 0;
		}
			
		public IEnumerator GetEnumerator()
		{
			return new PrimeCollection();
		}
	}

	class MainClass
	{
		public static void Main (string[] args)
		{
			PrimeCollection pc = new PrimeCollection();
			foreach(int p in pc)
				Console.WriteLine(p);
		}
	}
}





























