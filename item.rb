class Item
  
  attr_reader :is_ok, :value, :imposs_vals, :row, :col
  def value=(val)
    @value = val
    @imposs_vals = ALL - [val]
    @is_ok = true if @value > 0
  end
  
  def poss_vals
    (ALL - @imposs_vals).sort
  end

  def imposs_vals=(arr)
    @imposs_vals |= arr
    return if @is_ok
    if (@imposs_vals.size == SIZE-1)
      @value = (ALL - @imposs_vals)[0]
      @is_ok = true
    end
  end
  
  def add_imposs_vals(vals)
    self.imposs_vals=vals
  end

  def initialize(col, row, val)
    @col, @row = col, row
    if (val == 0)
      @value = 0
      @is_ok = false
      @imposs_vals = []
    else
      @value = val
      @is_ok = true
      @imposs_vals = ALL - [val]
    end
  end
  
  def inspect
    "col=#{col}  row=#{row} pos_vals=#{poss_vals}"
  end
  
  def to_s
    pv = poss_vals
    if @value > 0
      @value.to_s
    elsif  pv.size == 2
      pv.to_s
    else
      "[....]"
    end
  end
end