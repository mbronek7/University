package main

import (
	"fmt"
	"math"
)

func signum(x float64) int {
	if x < 0 {
		return -1
	} else {
		return 1
	}
}
func function(x float64) float64 {
	return math.Pow(x, 2) - 2*math.Cos(3*x+1)
}

func bisection(a0, b0, eps float64) float64 {
	eps0, a, b := eps, a0, b0
	for math.Abs(a-b) > eps {
		x1 := a + (b-a)/2.0
		if math.Abs(function(x1)) <= eps0 {
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

func main() {
	fmt.Println(bisection(-(math.Pi / 2.0), 0, 0.00001))
	fmt.Println(bisection(0, (math.Pi / 2.0), 0.00001))
}
