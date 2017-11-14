package main

import (
	"fmt"
)

func Sqrt(x, z float64) float64 {
	for i := 0; i < 15; i++ {
		z -= (z*z - x) / (2 * z)
	}
	return z
}

func main() {
	fmt.Println(Sqrt(3, 1.0))
	fmt.Println(Sqrt(3, 3/2.0))
	fmt.Println(Sqrt(3, 0.0))
	fmt.Println(Sqrt(3, 10))
	fmt.Println(Sqrt(3, 1/2.0))
}
