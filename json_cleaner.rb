require 'json'
# recursively clear keys-values
# by key-pattern

class JsonCleaner
   attr_reader :clear_data

   private 

   def initialize(json, pattern)
      @json = JSON.parse(json)
      @pattern = pattern
      @clear_data = clear_content(@json)
   end

   def clear_content(hash)
      hash = clear_hash(hash)
      go_deep(hash)
   end
   
   def go_deep(hash)
      hash.each_key{ |key| check_value(hash[key]) }
   end
   
   def clear_hash(hash)
      hash.delete_if { |key, value| key.match?(@pattern) } if hash.is_a?(Hash)
   end
   
   def check_value(value)
      if value.is_a?(Hash)
         clear_content(value)
      elsif value.is_a?(Array)
         check_array(value)
      else
         value
      end
   end
   
   def check_array(array)
      array.each do |element|
         if element.is_a?(String) && element.match?(PATTERN)
            array.delete(element)
         elsif element.is_a?(Hash) || element.is_a?(Array)
            check_value(element)
         end
      end
   end
end


if __FILE__ == $0
   PATTERN = /[nN]ame/
   #data = JSON.parse(File.read('11.json'))
   
   obj = JsonCleaner.new(File.read('11.json'), PATTERN)

   puts obj.clear_data.to_json   
end