package main

import (
	"fmt"
	"math"
)

type fn func(float64) float64

func function(x float64) float64 {
	return math.Pow((x - 10), 3)
}
func function2(x float64) float64 {
	return math.Pow((x - 10), 9)
}
func function3(x float64) float64 {
	return math.Pow((x - 3), 5)
}
func derivate3(x float64) float64 {
	return 5 * math.Pow((x-3), 4)
}
func derivate2(x float64) float64 {
	return 9 * math.Pow((x-10), 8)
}
func derivate(x float64) float64 {
	return 3 * math.Pow((x-10), 2)
}
func compute(r int64, x0 float64, f fn, d fn) float64 {
	xn := x0
	for i := 0; i < 500; i++ {
		xn1 := xn - ((float64(r) * f(xn)) / d(xn))
		if math.IsNaN(xn1) {
			fmt.Printf("Iteracja: %d ", i)
			break
		}
		xn = xn1
	}
	return xn
}

/*
func function(x float64) float64{
      return  math.Pow(x,2) * math.Pow(x-1,3) *(x+5)
}
func derivate(x float64) float64{
      return 2 * math.Pow(x-2,2) * x * (3 * math.Pow(x,2) + 11 * x - 5)
}
func compute(r int64) float64 {
	xn := 0.1
	for i := 0; i < 500; i++ {
		xn1 := xn - ((float64(r) * function(xn)) / derivate(xn))
        if math.IsNaN(xn1) {
         break
        }
        xn = xn1
	}
	return xn
}
*/
func main() {
	fmt.Println("dla Funkcji (x-10)^3, x0 = 0.01, r=3 , α =", compute(3, 0.01, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 0.0001, r=3 , α =", compute(3, 0.0001, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 0.000001, r=3 , α =", compute(3, 0.00001, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 0.0000001, r=3 , α =", compute(3, 0.0000001, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 1.0, r=3 , α =", compute(3, 1.0, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 1.5, r=3 , α =", compute(3, 1.5, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 5.0, r=3 , α =", compute(3, 5.0, function, derivate))
	fmt.Println("dla Funkcji (x-10)^3, x0 = 0.000000000001, r=3 , α =", compute(3, 0.000000000001, function, derivate))
	fmt.Println()
	fmt.Println("dla Funkcji (x-10)^9, x0 = 0.01, r=9 , α =", compute(9, 0.01, function2, derivate2))
	fmt.Println("dla Funkcji (x-10)^9, x0 = 0.0001, r=9 , α =", compute(9, 0.0001, function2, derivate2))
	fmt.Println("dla Funkcji (x-10)^9, x0 = 1, r=9 , α =", compute(9, 1.0, function2, derivate2))
	fmt.Println("dla Funkcji (x-10)^9, x0 = 5, r=9 , α =", compute(9, 5.0, function2, derivate2))
	fmt.Println("dla Funkcji (x-10)^9, x0 = 6, r=9 , α =", compute(9, 6.0, function2, derivate2))
	fmt.Println()
	fmt.Println("dla Funkcji (x-3)^5, x0 = 6, r=5 , α =", compute(5, 6.0, function3, derivate3))
	fmt.Println("dla Funkcji (x-3)^5, x0 = 16, r=5 , α =", compute(5, 16.0, function3, derivate3))
	fmt.Println("dla Funkcji (x-3)^5, x0 = 26, r=5 , α =", compute(5, 26.0, function3, derivate3))
	fmt.Println("dla Funkcji (x-3)^5, x0 = 1236, r=5 , α =", compute(5, 1236.0, function3, derivate3))
	fmt.Println("dla Funkcji (x-3)^5, x0 = 12346, r=5 , α =", compute(5, 12346.0, function3, derivate3))
	fmt.Println("dla Funkcji (x-3)^5, x0 = 9999996, r=5 , α =", compute(5, 9999996.0, function3, derivate3))
	fmt.Println("dla Funkcji (x-3)^5, x0 = 99999999999999999996, r=5 , α =", compute(5, 99999999999999999996.0, function3, derivate3))
}
