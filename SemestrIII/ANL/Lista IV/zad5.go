package main

import (
	"fmt"
	"time"
)

func timeTrack(start time.Time, name string) {
	elapsed := time.Since(start)
	fmt.Printf("%s took %s\n", name, elapsed)
}

func inverseByNewtonMethodTime(x int64) float64 {
	var a, b = 0.1, 0.1
	defer timeTrack(time.Now(), "inverse")
	for i := 0; i < 7; i++ {
		b = a * (2 - a*float64(x))
		a = b
	}
	return a
}
func inverseByNewtonMethod(x int64) float64 {
	var a, b = 0.1, 0.1
	for i := 0; i < 7; i++ {
		b = a * (2 - a*float64(x))
		a = b
	}
	return a
}
func inverseByNewtonMethodx0(x int64, b float64) float64 {
	var a = b
	for i := 0; i < 7; i++ {
		b = a * (2 - a*float64(x))
		a = b
	}
	return a
}
func inverseByNewtonMethodi(x int64, x0 float64, n int) {
	var a = x0
	var b float64
	for i := 0; i < n; i++ {
		b = a * (2 - a*float64(x))
		a = b
		fmt.Printf("Wartośc α dla %2d iteracji to: %.20f\n", i, a)
	}
}
func divide(x int64) float64 {
	defer timeTrack(time.Now(), "divide")
	return float64(1 / float64(x))
}
func main() {
	fmt.Printf("\n-------Wartośći dla różnych ilośći iteracji i R = 3-------\n\n")
	inverseByNewtonMethodi(3, 0.0001, 35)
	fmt.Printf("\n-------Różne wartości R ta sama wartość x0-------\n\n")
	fmt.Printf("x0 = 0.1 i R = 2 mamy α=%.30f\n", inverseByNewtonMethod(2))
	fmt.Printf("x0 = 0.1 i R = 3 mamy α=%.30f\n", inverseByNewtonMethod(3))
	fmt.Printf("x0 = 0.1 i R = 4 mamy α=%.30f\n", inverseByNewtonMethod(4))
	fmt.Printf("x0 = 0.1 i R = 5 mamy α=%.30f\n", inverseByNewtonMethod(5))
	fmt.Printf("x0 = 0.1 i R = 6 mamy α=%.30f\n", inverseByNewtonMethod(6))
	fmt.Printf("x0 = 0.1 i R = 7 mamy α=%.30f\n", inverseByNewtonMethod(7))
	fmt.Printf("\n-------Różne wartości x0 ta sama wartość R-------\n\n")
	fmt.Printf("x0 = 0.1 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 0.1))
	fmt.Printf("x0 = 0.2 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 0.2))
	fmt.Printf("x0 = 0.3 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 0.3))
	fmt.Printf("x0 = 0.4 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 0.4))
	fmt.Printf("x0 = 0.8 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 0.8))
	fmt.Printf("x0 = 0.9 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 0.9))
	fmt.Printf("x0 = 1.0 i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(3, 1.0))
	fmt.Printf("x0 = 10  i R = 3 mamy α=%g\n", inverseByNewtonMethodx0(7, 10))
	fmt.Printf("\n-------Porownanie dokladnosci-------\n\n")
	fmt.Printf("Dla R = 3 różnica pomiędzy naszym wzorem a wartoscia dokladna do okreslonego miejsca po przecinku = %.30f\n", inverseByNewtonMethod(3)-0.333333333333333333333333333333)
	fmt.Printf("Dla R = 3 różnica pomiędzy dzialaniem 1/3 a wartoscia dokladna do okreslonego miejsca po przecinku = %.30f\n", float64(1/3.0)-0.333333333333333333333333333333)
	fmt.Printf("Dla R = 2 różnica pomiędzy naszym wzorem a wartoscia dokladna do okreslonego miejsca po przecinku = %.30f\n", inverseByNewtonMethod(2)-0.5)
	fmt.Printf("Dla R = 2 różnica pomiędzy dzialaniem 1/3 a wartoscia dokladna do okreslonego miejsca po przecinku = %.30f\n", float64(1/2.0)-0.5)
	fmt.Printf("\n-------Porownanie czasowe-------\n\n")
	fmt.Printf("%.30f\n", inverseByNewtonMethodTime(3))
	fmt.Printf("%.30f\n", divide(3))
	fmt.Printf("%.30f\n", inverseByNewtonMethodTime(7))
	fmt.Printf("%.30f\n", divide(7))
}
