class Year
  @@year = 2019

  def self.current_year
    @@year
  end

  def self.set_current_year(year)
    @@year = year
  end
end