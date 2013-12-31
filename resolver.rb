require './sudoku.rb'

# HARD
arr = [
  [0,0,8, 0,0,7, 0,0,0],
  [3,0,0, 5,4,0, 2,0,0],
  [6,0,0, 0,0,0, 0,0,0],

  [0,4,1, 0,0,2, 0,0,0],
  [0,2,0, 8,1,3, 0,4,0],
  [0,0,0, 9,0,0, 6,2,0],

  [0,0,0, 0,0,0, 0,0,5],
  [0,0,7, 0,6,1, 0,0,2],
  [0,0,0, 2,0,0, 1,0,0]
]

#SIMLE
# arr = [
# [5,0,1, 8,0,0, 2,9,0],
# [0,2,0, 0,0,1, 0,7,0],
# [0,9,4, 0,0,3, 0,0,5],
# 
# [9,4,6, 0,0,8, 0,0,7],
# [0,1,0, 0,0,0, 0,6,0],
# [3,0,0, 6,0,0, 4,2,1],
# 
# [6,0,0, 7,0,0, 8,3,0],
# [0,3,0, 9,0,0, 0,1,0],
# [0,7,9, 0,0,2, 5,0,6]
# ]

#EXAMPLE
# arr = [
  # [2,0,0, 0,7,0, 0,3,8],
  # [0,0,0, 0,0,6, 0,7,0],
  # [3,0,0, 0,4,0, 6,0,0],
# 
  # [0,0,8, 0,2,0, 7,0,0],
  # [1,0,0, 0,0,0, 0,0,6],
  # [0,0,7, 0,3,0, 4,0,0],
# 
  # [0,0,4, 0,8,0, 0,0,9],
  # [0,6,0, 4,0,0, 0,0,0],
  # [9,1,0, 0,6,0, 0,0,2]
# ]

class Resolver
  
  def initialize(sudoku)
    @s = sudoku
  end
  
  def do_simple_check
    result = false
    begin
    result = false
    (0...SIZE).each {|row|
    (0...SIZE).each {|col|
        next if @s[col, row].is_ok
        @s[col, row].imposs_vals=@s.used_numbers_for(col, row)
        result = true if @s[col, row].is_ok
      }
    }
    end while result
  end

  def do_last_stand_check
    result = false
    begin
    result = false
    (0...SIZE).each {|row|
    (0...SIZE).each {|col|
        check_for_last_stand(col,row)
      }
    }
    end while result
  end
  
  def do_stripted_pair_check
    (0..8).each {|n|
      arr = @s.box(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs)
       
      
      arr = @s.column_at(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs)

      arr = @s.row_at(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs) 
    }    
  end
  
  private
  
  def clean_block(arr, hash)
    hash.each {|key, value|
      p "key=#{key} value=#{value} arr.size=#{arr.size}" 
      (arr - value).each{|item|
        p "col=#{item.col} row=#{item.row} item.add_imposs_vals(#{key})" 
        item.add_imposs_vals(key)
      }
    }
  end
  
  def check_for_pairs (arr)
    hash = {}
    arr.each do |item|
      pos_vals = item.poss_vals
      if (pos_vals.size == 2)
        hash[pos_vals] = (hash[pos_vals] || 0) + 1
      end
    end 
    
    result = {}  
    hash.each {|key, value| 
      #p "key=#{key} value=#{value} " if value > 1
      result[key] = arr.select{|item| item.poss_vals == key} if (value >= key.size) && (value > 1) 
    }
    result
  end

  def check_for_last_stand(col,row)
    return false if @s[col, row].is_ok
    rows = @s.row_at(row) - [@s[col, row]]
    val = check_array_for_last_stand(rows)
    @s[col, row].value=val if val > 0
    return true if val > 0
    
    
    cols = @s.column_at(col) - [@s[col, row]]
    val = check_array_for_last_stand(cols)
    @s[col, row].value=val if val > 0
    return true if val > 0
    
    box = @s.box_at(col,row) - [@s[col, row]]
    val = check_array_for_last_stand(box)
    @s[col, row].value=val if val > 0
    return true if val > 0
    return false
  end  
    
  def check_array_for_last_stand(arr)
    result = Array.new(SIZE + 1, 0)
    arr.each do |item|
      item.imposs_vals.each do |value|
        result[value] += 1
      end
    end
    for i in 1...SIZE
      return i if result[i] == SIZE-1 
    end
    return 0
  end
end


s = Sudoku.new(arr)
r = Resolver.new(s)
r.do_simple_check
r.do_last_stand_check
r.do_simple_check
r.do_last_stand_check
r.do_stripted_pair_check
puts s.to_string
