require './sudoku.rb'

arr = [
  [0,0,8, 0,6,0, 0,0,0],
  [6,3,0, 0,4,0, 1,0,0],
  [0,0,0, 1,0,8, 0,0,2],

  [0,0,0, 0,0,0, 0,1,9],
  [8,0,1, 0,0,0, 3,0,4],
  [7,6,0, 0,0,0, 0,0,0],

  [4,0,0, 9,0,5, 0,0,0],
  [0,0,6, 0,8,0, 0,5,3],
  [0,0,0, 0,7,0, 8,0,0]
]

arr_sol = [
  [5,1,8, 3,6,2, 4,9,7],
  [6,3,2, 7,4,9, 1,8,5],
  [9,4,7, 1,5,8, 6,3,2],
  
  [3,5,4, 8,2,6, 7,1,9],
  [8,2,1, 5,9,7, 3,6,4],
  [7,6,9, 4,3,1, 5,2,8],
  
  [4,8,3, 9,1,5, 2,7,6],
  [1,7,6, 2,8,4, 9,5,3],
  [2,9,5, 6,7,3, 8,4,1]
]

# TOO HARD
# arr = [
  # [0,0,8, 0,0,7, 0,0,0],
  # [3,0,0, 5,4,0, 2,0,0],
  # [6,0,0, 0,0,0, 0,0,0],
# 
  # [0,4,1, 0,0,2, 0,0,0],
  # [0,2,0, 8,1,3, 0,4,0],
  # [0,0,0, 9,0,0, 6,2,0],
# 
  # [0,0,0, 0,0,0, 0,0,5],
  # [0,0,7, 0,6,1, 0,0,2],
  # [0,0,0, 2,0,0, 1,0,0]
# ]

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
    @arr_sol = [
      [5,1,8, 3,6,2, 4,9,7],
      [6,3,2, 7,4,9, 1,8,5],
      [9,4,7, 1,5,8, 6,3,2],
      
      [3,5,4, 8,2,6, 7,1,9],
      [8,2,1, 5,9,7, 3,6,4],
      [7,6,9, 4,3,1, 5,2,8],
      
      [4,8,3, 9,1,5, 2,7,6],
      [1,7,6, 2,8,4, 9,5,3],
      [2,9,5, 6,7,3, 8,4,1]
    ]
  end
  
  def do_simple_check(s)
    result = false
    begin
    result = false
    (0...SIZE).each {|row|
    (0...SIZE).each {|col|
        next if s[col, row].is_ok
        raise 'AHTUNG!!!!' if s[col, row].is_ok
        s[col, row].imposs_vals=s.used_numbers_for(col, row)
        result = true if s[col, row].is_ok
      }
    }
    end while result
  end

  def do_last_stand_check(s)
    result = false
    begin
    result = false
    (0...SIZE).each {|row|
    (0...SIZE).each {|col|
        check_for_last_stand(col,row, s)
      }
    }
    end while result
  end
  
  def do_stripted_pair_check(s)
    (0..8).each {|n|
      arr = s.box(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs)
      
      arr = s.column_at(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs)

      arr = s.row_at(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs) 
    }    
  end
  
  def do_cheat(x,y,v)
    @s[x,y].value = v
  end
  
  def check
    @s.check
  end
    
  def do_brute
    col, row = @s.search_next_pair
    s = make_suggestion(col, row, @s)
    puts "============================================================ HERE IS ==============================================="
    puts s.to_string
    puts "================================================================ the solution ==========================================="
  end
  
    
  def make_suggestion (col, row, s)
    puts "s[#{col}, #{row}] = #{s[col, row]}"
    ary = s[col, row].poss_vals
    ary.each{|value|
      begin
        puts "trying  #{value} on #{col}x#{row}"
        s.switch_to_virtual_mode 
        s[col, row].value = value
        do_iteration(s)
        puts s.to_string
        s.compare(@arr_sol)
        s.check
        puts "Done! Now cloning..." 
        new_s = s.deep_clone
        puts new_s.to_string
        new_col, new_row = new_s.search_next_pair
        puts "next is #{new_col}x#{new_row}"
        s =  make_suggestion(new_col, new_row, new_s)
        puts "Oh, yeah! #{value} in #{col}x#{row} is what you need!"
        s.commit!
        puts "Yes!!! " * 10 if s.resolved?
        return s if s.resolved?
      rescue Sudoku::NoCellsFoundException => ex
        raise Sudoku::WrongSolutionException, "No cells found, but it is not a solution" if !s.resolved?
        puts
        puts
        puts
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts
        puts
        puts
        return s
      rescue Sudoku::WrongSolutionException => ex
        puts "#{value} on #{col}x#{row} doesn't work cause of #{ex}, rollback.."
        puts s.to_string
        s.revert!
        #puts ex.backtrace
        next
      end   
    }
    return s if s.resolved?
    raise Sudoku::WrongSolutionException, "No solution found on #{col}x#{row}"
  end

  
  def do_iteration(s=@s)
    do_simple_check(s)
    do_last_stand_check(s)
    do_stripted_pair_check(s)
  end
  
  
  private

  
  def clean_block(arr, hash)
    hash.each {|key, value|
     # puts "#{arr - value}"
      (arr - value).each{|item|
        #puts "col=#{item.col}  row=#{item.row}"
        item.add_imposs_vals(key)
      }
    }
  end
  
  def check_for_pairs (arr)
    hash = {}
    arr.each do |item|
      pos_vals = item.poss_vals
      if (pos_vals.size >= 2)
        hash[pos_vals] = (hash[pos_vals] || 0) + 1
      end
    end 
    
    result = {}  
    hash.each {|key, value| 
     result[key] = arr.select{|item| item.poss_vals == key} if (value >= key.size) && (value > 1)
     #puts "key = #{key}, value=#{arr.select{|item| item.poss_vals == key}}" if (value >= key.size) && (value > 1)
    }
    result
  end

  def check_for_last_stand(col,row, s)
    return false if s[col, row].is_ok
    rows = s.row_at(row) - [s[col, row]]
    val = check_array_for_last_stand(rows)
    s[col, row].value=val if val > 0
    return true if val > 0
    
    
    cols = s.column_at(col) - [s[col, row]]
    val = check_array_for_last_stand(cols)
    s[col, row].value=val if val > 0
    return true if val > 0
    
    box = s.box_at(col,row) - [s[col, row]]
    val = check_array_for_last_stand(box)
    s[col, row].value=val if val > 0
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


s = Sudoku.from_array(arr)
r = Resolver.new(s)
5.times do
  puts s.to_string
  r.do_iteration
end
# s[0,0].value = 1
# r.do_iteration
puts 
puts
p r.do_brute
puts
puts 
r.check
puts s.to_string



# r.do_suggestion
# r.do_cheat(1,1,7)
# r.do_simple_check
# r.do_last_stand_check
# r.do_stripted_pair_check
# puts s.to_string
# r.do_cheat(1,0,5)
# r.do_simple_check
# r.do_last_stand_check
# r.do_stripted_pair_check
# puts s.to_string
# r.do_cheat(4,3,5)
# r.do_simple_check
# r.do_last_stand_check
# r.do_stripted_pair_check
# r.do_simple_check
#puts s.to_string
