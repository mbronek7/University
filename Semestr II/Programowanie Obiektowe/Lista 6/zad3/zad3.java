import java.io.*;
import java.lang.*;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.Queue;
import java.util.Random;
import java.util.LinkedList;


class Bufor<T>{
	int sizeofbufor = 0; // rozmiar
	Queue<T> buf;
	public Bufor(int sizeofbufor){
		this.sizeofbufor = sizeofbufor;
		buf = new ConcurrentLinkedQueue<T>(); // kolejka FIFO, ktora jest nieograniczona i działa bezpiecznie z watkami
	}
	
	public boolean isFull(){
		return buf.size() == sizeofbufor; // jak rowne maxowi to jest juz pełne
	}
	public boolean isEmpty(){
		return buf.isEmpty();
	}
	
	public synchronized void addElem(T elem){//Synchronizacje jest potrzebna po to, by współdzielenie zasobu przez kilka wątków nie prowadziło do niespójnych stanów zasobu. 
		if(isFull()){
			try {
				wait();
				} 
			catch(InterruptedException e) {
				System.out.println("InterruptedException caught");
			} 
		}
		notify(); 
		buf.add(elem);
	}
	public synchronized T getElem(){
		if(isEmpty()){

			try {
				wait();
				} 
			catch(InterruptedException e) {
				System.out.println("InterruptedException caught");
			} 
		}
		notify(); 
		return buf.poll();
	}
}
/*
 * implements Runnable	wymaga implementacji run()
 * extends Thread		wymaga implementacji run()
 * extends Runnable		wymusza na wszystkich klasach ktore implementuja interfejs ktory 
 * 						rozszerza Runnable implementacje run() (wspoldzielenie interfejsu)
 */
class Producent <T> implements Runnable
{
	Bufor<String> myBuf;
	
	public Producent(Bufor buf){
		this.myBuf = buf;
	}
	
	public void run()
	{
		while(true){

			myBuf.addElem("wynik pracy producenta");//+System.nanoTime());
			System.out.println("wyprodukowałem");
		}
	}
}

class Konsument <T> extends Thread
{
	Bufor<T> myBuf;
	
	public Konsument(Bufor buf){
		this.myBuf = buf;
	}
	
	public void run() 
	{
		while(true){
			System.out.println("konsumuje : " + myBuf.getElem());
		}
	}
}

public class zad3 {
	static public void main(String[] args) throws InterruptedException
	{
		Bufor <String> buf = new Bufor<String> (10);
		
		Producent producent = new Producent(buf);
		Konsument konsument = new Konsument(buf);
		
		Thread t1 = new Thread(producent);
		Thread t2 = new Thread(konsument);
		t1.setPriority(1);
		t2.setPriority(10);
		
		
		t1.start();
		t2.start();
		
		for(Integer i = 0; i < 100; i++){
			Thread.sleep(10);
		}
		
		t1.stop();
		t2.stop();
	}
}