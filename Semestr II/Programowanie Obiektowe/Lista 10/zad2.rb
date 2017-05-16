class Kolekcja
    def initialize
        @head = nil
        @tail = nil
        @length = 0
    end

    def << val
        new_node = Node.new val

        if @length == 0
            @head = new_node
            @tail = new_node
        else
            if new_node.val <= @head.val
                @head.prev = new_node
                new_node.next = @head
                @head = new_node
            elsif new_node.val > @tail.val
                @tail.next = new_node
                new_node.prev = @tail
                @tail = new_node
            else
                node = @head
                while new_node.val <= node.val
                    node = node.next
                end

                new_node.next = node
                node.prev = new_node
            end
        end

        @length += 1
    end

    def length
        @length
    end

    def get i
        node = @head
        i.times { node = node.next }
        node.val
    end

    class Node
        def initialize val
            @next = nil
            @prev = nil
            @val = val
        end

        attr_accessor :next
        attr_accessor :prev
        attr_accessor :val
    end
end

class Wyszukiwanie
    def self.szukaj1 kolekcja, val
        l = 0
        r = kolekcja.length - 1

        while l <= r
            mid = (l + r) / 2
            mid_val = kolekcja.get(mid)

            if mid_val == val
                return true
            elsif mid_val < val
                l = mid + 1
            else
                r = mid - 1
            end
        end

        return false
    end

    def self.szukaj2 kolekcja, val
        (kolekcja.length).times do |i|
            kolekcja.get(i) == val and return true
        end
        false
    end
end

szukaj_kolekcja = Kolekcja.new
20.downto(0) do |i|
    szukaj_kolekcja << i
end

puts Wyszukiwanie.szukaj1 szukaj_kolekcja, 13
puts Wyszukiwanie.szukaj2 szukaj_kolekcja, -7
