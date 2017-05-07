import Data.List
import Data.Char




integerToString :: Integer -> String


integerToString 0 = "0"
integerToString n = (reverse.unfoldr (\n ->
	if n == 0 then Nothing
		else Just ((intToDigit.fromEnum) (mod n 10), div n 10)   )) n

fromEnum 3

