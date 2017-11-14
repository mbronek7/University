package main

import (
	"fmt"
	"math"
)

func compute(x int64) float64 {
	xn := 0.1
	for i := 0; i < 8; i++ {
		xn1 := 0.5 * xn * (3 - float64(x)*math.Pow(xn, 2)) // 0.5 * xn(3-a*xk^2)
		xn = xn1
	}
	return xn
}

func computei(x int64, x0 float64, n int) float64 {
	xn := x0
	for i := 0; i < n; i++ {
		xn1 := 0.5 * xn * (3 - float64(x)*math.Pow(xn, 2)) // 0.5 * xn(3-a*xk^2)
		xn = xn1
		fmt.Printf("Wartość dla %2d iteracji: %.30f\n", i+1, xn)
	}
	return xn
}
func computex0(x int64, x0 float64) float64 {
	xn := x0
	for i := 0; i < 15; i++ {
		xn1 := 0.5 * xn * (3 - float64(x)*math.Pow(xn, 2)) // 0.5 * xn(3-a*xk^2)
		xn = xn1
	}
	return xn
}

func main() {
	fmt.Println("\nWartości przy kolejnych iteracjach:\n")
	computei(1000000, 1/1000000.0, 30)
	fmt.Println("\nWartosci obliczeń dla kolejnych a od 1 do 15:\n")
	for i := 1; i < 16; i++ {
		fmt.Printf("Wartość dla a = %2d to: %.30f --- wartość policzona bezpośrednio: %.30f\n", i, compute(int64(i)), (1 / math.Sqrt(float64(i))))
	}
	fmt.Println("\nWartośćo obliczeń dla a = 3 i różnych wartości x0\n")
	fmt.Printf("Wartość α dla x0 = 0.1 --- %g\n", computex0(3, 0.1))
	fmt.Printf("Wartość α dla x0 = 0.2 --- %g\n", computex0(3, 0.2))
	fmt.Printf("Wartość α dla x0 = 0.4 --- %g\n", computex0(3, 0.4))
	fmt.Printf("Wartość α dla x0 = 0.5 --- %g\n", computex0(3, 0.5))
	fmt.Printf("Wartość α dla x0 = 0.6 --- %g\n", computex0(3, 0.6))
	fmt.Printf("Wartość α dla x0 = 0.7 --- %g\n", computex0(3, 0.7))
	fmt.Printf("Wartość α dla x0 = 0.8 --- %g\n", computex0(3, 0.8))
	fmt.Printf("Wartość α dla x0 = 1.1 --- %g\n", computex0(3, 1.1))
	fmt.Printf("Wartość α dla x0 = 1.2 --- %g\n", computex0(3, 1.2))
	fmt.Printf("Wartość α dla x0 = 1.3 --- %g\n", computex0(3, 1.3))
	fmt.Printf("Wartość α dla x0 = 1.5 --- %g\n", computex0(3, 1.5))

}
