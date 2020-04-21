require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if @columns.nil?
      data = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
        LIMIT
          0
      SQL
      # debugger
      @columns = data.first.map{ |ele| ele.to_sym }      
    end

    @columns
  end

  # Adds getters and setters for each column
  def self.finalize!
    self.columns.each do |column|
      column = column.to_sym # Might be necessary?
      getter = column.to_sym
      setter = column.to_s.concat("=").to_sym

      define_method(getter) do
        attributes[column]
      end

      define_method(setter) do |new_val|
        attributes[column] = new_val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
    @table_name
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    objects = results.each { |result| self.new(result) }

    objects
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value| # attr_name is already a symbol
      # debugger
      attr_name = attr_name.to_sym # Necessary for ::all to return all the rows
      setter = attr_name.to_s.concat("=").to_sym

      if !self.class.columns.include?(attr_name)
        raise ArgumentError.new("unknown attribute '#{attr_name}'")
      else
        self.send(setter, value)
      end

    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
