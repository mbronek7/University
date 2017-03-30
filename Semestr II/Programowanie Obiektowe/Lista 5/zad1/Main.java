import java.util.ArrayList;
import java.util.Collections;
class ElementStructure<T> {
    protected Comparable<T> val;

    public Comparable<T> getVal() {//pobieram wartosc
        return val;
    }

    public void setVal(Comparable<T> val) {//ustalam wartosc
        this.val = val;
    }


    private ElementStructure<T> next;

    public ElementStructure getNext() { // pobieram nastepny element
        return next;
    }
http://
    public void setNext(ElementStructure<T> next) { //ustawiam nowy nastepny element
        this.next = next;
    }


    ElementStructure(Comparable<T> v) {//konstruktor 
        val = v;
        next = null;
    }

    void push(Comparable<T> v) {
        if(next == null) {
            next = new ElementStructure(v);
        } else if (v.compareTo((T) next.getVal()) <= 0) { //metoda ta zwraca zero gdy są równe -1 jak mniejsze i 1 jak wieksze 
            ElementStructure temp = next;
            next = new ElementStructure(v);
            next.setNext(temp);
        } else {
            next.push(v);
        }
        /*while(v.compareTo((T) next.getVal()) > 0)
        next.push(v);
        ElementStructure temp = next;
            next = new ElementStructure(v);
            next.setNext(temp);*/
    }
}

class SList<T> {
    int size;
    ElementStructure<T> first;
    SList() {
        size = 0;
        first = null;
    }

    public void AddElement(Comparable<T> v) {
        if(size == 0) {
            first = new ElementStructure(v);
            size += 1;
        }
        else {
            if(v.compareTo((T) first.getVal()) <= 0) {
                ElementStructure<T> t = new ElementStructure(v);
                t.setNext(first);
                first = t;
            } else {
                first.push(v);
            }
        }
    }

    public T get() {
        return (T) first.getVal();
    }

    public void RemoveFirstElement() {
        if(first == null)  {
            return;
        }
        ElementStructure tmp = first.getNext();//jak lista nie jest pusta to drugi element ustawiam jaka pierwszy
        first = tmp;
    }

    public void PrintallElements() {
        ElementStructure tmp = first;
        System.out.print("Head");
        while(tmp != null) {
            System.out.print("-->");
            System.out.print(tmp.getVal());
            tmp = tmp.getNext();
        }
        System.out.println();
    }
}




//Czesc druga zadania

abstract class Stopien implements Comparable<Stopien> {//Interfejs ten wymusza zaimplementowanie metody compareTo.
    public Integer ktory_w_hierarchi;
    public abstract Integer hierarchizacja();//abstract bo bez deklaracji deklaruje pozniej w poszczegonych
    public int compareTo(Stopien other) {//metoda ta zwraca zero gdy są równe -1 jak mniejsze i 1 jak wieksze 
        return hierarchizacja().compareTo(other.hierarchizacja());//other przeciwienstwo this
    }
    public abstract String toString();//znowu szczegolowa definicja dla kazdej inna jest
};

class Marszałek extends Stopien {
    public Integer hierarchizacja() {
        return ktory_w_hierarchi;
    }
    Marszałek() {
        ktory_w_hierarchi = 1;
    }

    public String toString() {
        return " Marszałek " ;
    }
}

class Generał extends Stopien {
    public Integer hierarchizacja() {
        return ktory_w_hierarchi;
    }
    Generał() {
        ktory_w_hierarchi = 2;
    }
    public String toString() {
        return " Generał " ;
    }
}

class Pułkownik extends Stopien {
    public Integer hierarchizacja() {
        return ktory_w_hierarchi;
    }
    Pułkownik() {
        ktory_w_hierarchi = 3;
    }

    public String toString() {
        return " Pułkownik " ;
    }
}

class Major extends Stopien {
    public Integer hierarchizacja() {
        return ktory_w_hierarchi;
    }
    Major() {
        ktory_w_hierarchi = 4;
    }

    public String toString() {
        return " Major ";
    }
}
class Kapitan extends Stopien {
    public Integer hierarchizacja() {
        return ktory_w_hierarchi;
    }
    Kapitan() {
        ktory_w_hierarchi = 5;
    }

    public String toString() {
        return " Kapitan ";
    }
}
class Szeregowy extends Stopien {
    public Integer hierarchizacja() {
        return ktory_w_hierarchi;
    }
    Szeregowy() {
        ktory_w_hierarchi = 10;
    }

    public String toString(){
        return " Szeregowy ";
    }
}
public class Main {
    public static void main(String[] args) {
        SList<String> my_collection = new SList();
        my_collection.AddElement("ala");
        my_collection.AddElement("wierzchoslawa");
        my_collection.AddElement("basia");
        my_collection.AddElement("bernardeta");
        my_collection.AddElement("karolina");
        my_collection.AddElement("katarzyna");
        my_collection.PrintallElements();
        my_collection.RemoveFirstElement();
        my_collection.RemoveFirstElement();
        my_collection.RemoveFirstElement();
        my_collection.PrintallElements();
        my_collection.RemoveFirstElement();
        my_collection.RemoveFirstElement();
        my_collection.PrintallElements();

        ArrayList<Stopien> list = new ArrayList<Stopien>();
        list.add(new Szeregowy());
        list.add(new Generał());
        list.add(new Major());
        list.add(new Marszałek());
        list.add(new Pułkownik());

        Collections.sort(list);
        for(Stopien t : list) System.out.println(t);
    }
}
