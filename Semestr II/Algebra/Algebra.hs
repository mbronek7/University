
-- Program liczacy przewidywaną ocenę z Algebry 
import System.IO
import Data.Char  


wynik :: (RealFloat a) => (a,a,a) -> String
wynik (listy, kol1, kol2)
      | ocena <= 0.35 = "Nie zdasz"
      | ocena <= 0.5  = "Ocena = 3.0"
      | ocena <= 0.6  = "Ocena = 3.5"
      | ocena <= 0.7  = "Ocena = 4.0"
      | ocena <= 0.8  = "Ocena = 4.5"
      | otherwise     = "Ocena = 5.0"
    where 
    ocena = ((kol1 / 70 + kol2 / 70) / 2 + listy / 140) / 2


  
