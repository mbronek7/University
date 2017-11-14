package main

import "fmt"

//Potrzebna ilość cykli = (1 / częstotliwość pożądana) / (preskaler / częstotliwość zegara)
func cykle(preskaler float64) float64{
   return ( 1.0 / 37900 ) / ( preskaler / 1000000 )
}

func main(){
    fmt.Println(cykle(1))
    fmt.Println(cykle(8))
    fmt.Println(cykle(64))
    fmt.Println(cykle(256))
    fmt.Println(cykle(1024))
}

