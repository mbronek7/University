package main

import (
	"fmt"
	"math"
)

const Alfa = 0.06469263559947960

func signum(x float64) int {
	if x < 0 {
		return -1
	} else {
		return 1
	}
}
func function(x float64) float64 {
	return x*math.Pow(math.E, -x) - 0.06064
}

func bisection(a0, b0, eps float64) float64 {
	eps0, a, b := 0.0000001, a0, b0
	for math.Abs(a-b) > eps {
		x1 := a + (b-a)/2.0
		if function(x1) <= eps0 {
			break
		}
		if signum(function(x1)) != signum(function(a)) {
			b = x1
		} else {
			a = x1
		}
	}
	return a + (b-a)/2.0

}

func nbisection(a0 float64, b0 float64, n int) float64 {
	a, b := a0, b0
	for i := 0; i < n; i++ {
		x1 := a + (b-a)/2.0
		if signum(function(x1)) != signum(function(a)) {
			b = x1
		} else {
			a = x1
		}
	}
	return a + (b-a)/2.0

}

func realDefect(n int) float64 {
	return math.Abs(Alfa - nbisection(0, 1, n))
}

func valuationDefect(n int) float64 {
	return math.Pow(2, float64(-n-1))
}
func compare(n int) {
	for i := 0; i < 16; i++ {
		fmt.Printf("rzeczywista wartosc bledu %25g i oszacowana wartosc bledu %20g dla n = %d\n", realDefect(i), valuationDefect(i), i)
	}
}

func main() {
	compare(15)
}
