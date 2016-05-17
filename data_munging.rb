class DataSheets

  def initialize(file_name, minuend_column, subtrahend_column, label_column, category)
    @file_name = file_name
    @column1 = minuend_column #column to be subtracted from
    @column2 = subtrahend_column #column showing amount to subtract
    @label_column = label_column #column needed for output(i.e. team name for soccer file and day of month for temperature file
    @category = category #needed to route for proper output
    @arr = []
    @label_value = String.new
  end

  def prep_file
    f = File.open(@file_name, "r")
    f.each_line do |l|
      puts l
      @arr <<  l.split(" ")
    end
  end

  def compare_difference
    difference = (@arr[2][@column1].to_i - @arr[2][@column2].to_i).abs
    #.abs used to avoid situation where negative numbers may distort the ranking of the spread
    @arr.each do |line|
      if (line[0]) =~ /\d/ && (difference > (line[@column1].to_i - line[@column2].to_i).abs) 
        #RegEx attempts to ignore rows without data(e.g. column names, separation lines)
        difference = (line[@column1].to_i - line[@column2].to_i).abs
        @label_value = line[@label_column]
      end
    end
  end

  def output_results
    if @category == "soccer"
      puts "#{@label_value} had the smallest difference in ‘for’ and ‘against’ goals."
    elsif @category == "weather"
      puts "Day #{@label_value} saw the smallest temperature spread."
    end
  end
end
  
ds = DataSheets.new("./datamunging/weather_data.txt", 1, 2, 0, "weather")
# Alternative arguments to run the other data file:
#ds = DataSheets.new("./datamunging/soccer_data.txt", 6, 8, 1, "soccer")
ds.prep_file
ds.compare_difference
ds.output_results
      