require_relative 'drzewo_binarne.rb'
require_relative 'string_bt.rb'

r = DrzewoBinarne.new(4)
r.wstaw(r.root, 6)
r.wstaw(r.root, 1)
r.wstaw(r.root, 2)
p "Drzewo:"
p r.to_s
p "Czy zawiera 6"
p r.istnieje?(6, r.root)
p "Usuwam 6"
r.usun(6)
p "Czy zawiera 6"
p r.istnieje?(6, r.root)
p "Drzewo:"
p r.to_s
p "Wstawiam 6"
r.wstaw(r.root, 6)
p "Zawiera 6?"
p r.istnieje?(6, r.root)
p "Drzewo:"
p r.to_s