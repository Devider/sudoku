require './item.rb'


SIZE = 9
ALL = [1,2,3,4,5,6,7,8,9]
class Sudoku
  
  def initialize(arr)
    @arr = arr
    @in_virtual_mode = false
  end
  
  def self.from_array(arr)
    @arr = []
    (0...SIZE).each {|y|
      row = []
      (0...SIZE).each {|x|
        row << Item.new(x, y, arr[y][x])
      }
      @arr << row
    }
    @in_virtual_mode = false
    self.new(@arr)
  end
  
  def self.from_items_array(items_arr)
    self.new(items_arr)
  end

  def row_at(num)
    @arr[num]
  end

  def column_at(num)
    arr = []
    (0...SIZE).each {|y|
      arr << @arr[y][num]
    }
    arr
  end

  def box_at(col, row)
    x_arr = (0...SIZE).to_a.select {|k| k / 3 == (col) / 3}
    y_arr = (0...SIZE).to_a.select {|k| k / 3 == (row) / 3}
    block = []
    y_arr.each{|y|
      x_arr.each{|x|
        block << @arr[y][x]
      }
    }
    block
  end
  
  # 1 2 3
  # 4 5 6
  # 7 8 9
  
  def box(number)
    n = number
   
    x_arr = (0...SIZE).to_a.select {|k| k / 3 == (n) % 3}
    y_arr = (0...SIZE).to_a.select {|k| k / 3 == (n) / 3}
    block = []
    y_arr.each{|y|
      x_arr.each{|x|
        block << @arr[y][x]
      }
    }
    block
  end
  
  def used_numbers_for(col, row)
    to_array(row_at(row) | column_at(col) | box_at(col,row)) - [@arr[row][col].value]
  end
  
  def to_string
     out = ""
    (0...SIZE).each {|y|
      out << "\n" if y%3 == 0 && y != 0
      tmp = @arr[y].map{|item| item.value > 0 ? item.value.to_s + (" " * 26) : item.poss_vals.to_s + (" " * ((item.imposs_vals.size*3) ))}.join(" ") + "\n"
      out << tmp 
    }
    out   
  end

  def to_s
    out = ""
    (0...SIZE).each {|y|
      out << "\n" if y%3 == 0 && y != 0
      tmp = @arr[y].map{|item| item.value > 0 ? item.value : "?"}.join(" ") + "\n"
      tmp.insert(6, ' ')
      tmp.insert(12, ' ')
      out << tmp 
    }
    out
  end

  def to_array (arr)
    arr.map{|item| item.value}.select{|i| i > 0}
  end
  
  def search_next_pair
    (0...9).each{|row|
      (0...9).each{|col|
        next if (@arr[row][col].is_ok)
        return col, row
      }
    }
    raise NoCellsFoundException, 'No more cells found'
  end
  
  def deep_clone
    a = Marshal.load(Marshal.dump(@arr))
    Sudoku.from_items_array a
  end
  
  def [](col,row)
    @arr[row][col]
  end
  
  def check
    (0..8).each do |n|
      check_block(column_at(n))
      check_block(row_at(n))
      check_block(box(n))
    end
  end
  
  def compare(arr)
    (0...SIZE).each{|row|
      (0...SIZE).each{|col|
        next if !@arr[row][col].is_ok
        if @arr[row][col].value != arr[row][col]
          puts "problem in cell #{col}x#{row}: expctected #{arr[row][col]}, found #{@arr[row][col]}!"
          return
        end  
      } 
    }   
    puts "No difference found!"
  end
  
  def switch_to_virtual_mode
    raise "ALLREADY in VIRTUAL Mode!" if @in_virtual_mode
    @arr_backup = Marshal.load(Marshal.dump(@arr))
    @in_virtual_mode = true
  end

  def virtual_mode?
    @in_virtual_mode
  end
  
  def revert!
    raise "NOT in VIRTUAL Mode!" if !@in_virtual_mode
    @arr = Marshal.load(Marshal.dump(@arr_backup))
    @arr_backup = nil
    @in_virtual_mode = false
  end
  
  def commit!
    @arr_backup = nil
    @in_virtual_mode = false  
  end
  
  def resolved?
    (0...SIZE).each{|row|
      (0...SIZE).each{|col|
        return false if !@arr[row][col].is_ok
        return false if @arr[row][col].poss_vals.size != 1
      } 
    }
    true      
  end
  
  class WrongSolutionException<StandardError
  end

  class NoCellsFoundException<StandardError
  end  
  private
  def check_block(arr)
    resolved = arr.select{|item| item.is_ok }.map{|item| item.value}
    unresolved = arr.select{|item| !item.is_ok }.map{|item| item.poss_vals}
    bad = unresolved.select{|ary| ary.size == 0}
    raise WrongSolutionException, "There are [] values in #{resolved}/#{unresolved}/#{bad}!" if bad.size > 0 
    raise WrongSolutionException, "Illegal state of pussle checking #{resolved}!!!" if resolved.uniq.size != resolved.size  
    raise WrongSolutionException, "Wrong checksum:#{resolved.size}+#{unresolved.size} in #{arr}!!!" if resolved.uniq.size + unresolved.size != SIZE
  end
end