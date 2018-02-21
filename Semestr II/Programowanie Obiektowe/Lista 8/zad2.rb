
 def czarnyczybialy?
     x = rand(100)
     if x % 2 == 0
       return 0
     else
       return 7
    end
 end


 class Image
   def image
     @image
   end

   def *(img)  # koniunkcja bitow
     newIm = ImageBW.new(@width,@height)
     (0...@height).each do |y|
       (0...@width).each do |x|
         newIm.image[y][x] = @image[y][x] & img.image[y][x]  # tu stosuje koniunkcje &
       end
     end
     newIm
   end

   def +(img)  # alternatywa bitowa
     newIm = ImageBW.new(@width,@height)
     (0...@height).each do |y|
       (0...@width).each do |x|
         newIm.image[y][x] = @image[y][x] | img.image[y][x]  # tu stosuje alternatywe
       end
     end
     newIm
   end

     def narysuj
    (0...@height).each do |y|
      (0...@width).each do |x|

        printf( "\x1B[%im%s%s", 90+@image[y][x], "▇", "\033[0m" ) # \x do wyswietlania koloe
      end
      puts
    end
    puts
  end

 end

 class ImageBW < Image
   
  def initialize(width, height)
    @width  = width
    @height = height
    @image = Array.new(height) {Array.new(width)  {czarnyczybialy?}}

  end

end

class ImageC < Image
  def initialize(width, height)
    @width  = width
    @height = height
    @image = Array.new(height) { Array.new(width) { rand(8) } }

  end

end

(90 ... 98).each do |n|
    printf( "%i   \x1B[%im %s %s  \n", n%10, n, "█", "\033[0m" )
 end


  imblack = ImageBW.new(40,10)
  imblack.narysuj
  im1 = ImageC.new(40,10)
  im2 = ImageC.new(40,10)
  im3 = im1*im2
  im4 = im1+im2
  im1.narysuj
  im2.narysuj
  im3.narysuj
  im4.narysuj
  im5 = ImageBW.new(40,10)
  im5.narysuj
