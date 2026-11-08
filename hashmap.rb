class Hashmap
    attr_accessor :buckets, :capacity
    def initialize
        @load_factor = 0.75
        @capacity = 16
        @buckets = Array.new(@capacity, nil)
    end
    def hash(key)
        hash_code = 0
        prime_number = 31
      
        key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
      
        hash_code % @capacity
    end

    def set(key,value,node = @buckets[hash(key)])
        raise IndexError if hash(key).negative? || hash(key) >= @buckets.length

       if self.length >= (@capacity * @load_factor)
            self.re_populate_map
        end

        if node == nil
            @buckets[hash(key)] = Node.new(key,value)
            return
        end

        if node.key == key
            node.value = value
        elsif node.next_node == nil
          node.next_node = Node.new(key,value)
        else
            set(key, value, node.next_node)
        end  
    end

    def get(key, node = @buckets[hash(key)])
        return nil if node == nil
        return node.value if node.key == key
        get(key, node.next_node)
    end

    def has?(key, node = @buckets[hash(key)])
        return false if node == nil
        return true if node.key == key
        has?(key, node.next_node)
    end

    def remove(key, node = @buckets[hash(key)])
        return nil if node == nil || (node.key != key && node.next_node == nil)
         if node.key == key
            value = node.value
            @buckets[hash(key)] = node.next_node
            return value
         end
        if node.next_node.key == key
            value = node.next_node.value
             node.next_node = node.next_node.next_node
            value
        end
    end

    def length
        count = 0
      
        @buckets.each do |bucket|
          current = bucket
      
          while current
            count += 1
            current = current.next_node
          end
        end
      
        count
      end

    def clear
         @buckets = []
    end

    def keys
        keys = []
        @buckets.each do |bucket|
            current = bucket
        
            while current
              keys << current.key
              current = current.next_node
            end
          end
        
          keys
    end

    def values
        values = []
        @buckets.each do |bucket|
            current = bucket
            while current
                values << current.value
                current = current.next_node
            end
        end
        values
    end

    def keysr
        count_buckets(0)
    end
      
    def count_buckets(index)
        return [] if index == @buckets.length
      
        collect_keys(@buckets[index]) + count_buckets(index + 1)
    end

    def collect_keys(node)
        return [] if node.nil?
        [node.key] + collect_keys(node.next_node)
    end

    def entries
        pairs = []
        @buckets.each do |bucket|
            current = bucket
            while current
                pairs << [current.key, current.value]
                current = current.next_node
            end
        end
        pairs
    end

    def re_populate_map
            @capacity *= 2 
            entries = self.entries
            @buckets = Array.new(@capacity, nil)
            entries.each do |key, value|
                set(key,value)
            end
    end
end

class Node
    attr_accessor :value, :next_node, :key

    def initialize(key,value)
        @key = key
        @value = value
        @next_node = nil
    end

end