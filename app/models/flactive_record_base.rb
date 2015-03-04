module FlactiveRecord
  class Base
    def self.inherited(base)
      base.class_eval do
        attr_accessor *column_names
      end
    end

    def self.exec(sql, args=[])
      DBConnection.instance.exec(sql, args)
    end

    def self.connection
      DBConnection.instance.connection
    end

    def self.table_name
      Inflecto.pluralize(self.name).downcase
    end

    def self.column_names
      sql = <<-SQL
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name='#{table_name}'
      SQL

      exec(sql).flat_map{|column| column.values}
    end

    def self.all
      sql = <<-SQL
        SELECT *
        FROM #{table_name}
      SQL

      results = exec(sql)
      results.map do |row|
        new(row)
      end
    end

    def self.find(id)
      sql = <<-SQL
        SELECT *
        FROM #{table_name}
        WHERE id=$1
        LIMIT 1
      SQL

      results = exec(sql, [id])
      results.map do |row|
          new row
      end.first
    end

    def initialize(options={})
      options.each do |property, value|
        public_send("#{property}=", value)
      end
    end

    def save
      if self.id
        update
      else
        insert
      end
    end

    private
    def update
      columns = self.class.column_names.select do |column|
        public_send(column)
      end

      values = columns.map do |column|
        "'#{public_send(column)}'"
      end
      set_values = columns.zip(values).map do |column, values|
        "#{column}=#{values}"
      end

      sql = <<-SQL
        UPDATE #{self.class.table_name}
        SET #{set_values.join(",")}
        WHERE id=#{id}
      SQL

      result = exec(sql)
      self
    end

    def insert
      columns = self.class.column_names.select do |column|
        public_send(column)
      end

      values = columns.map do |column|
        "'#{public_send(column)}'"
      end

      sql = <<-SQL
        INSERT INTO #{self.class.table_name}
        (#{columns.join(", ")})
        VALUES
        (#{values.join(", ")})
        returning id
      SQL

      result = exec(sql)
      self.id = result[0]["id"]
      self
    end

    def exec(sql, args=[])
      self.class.exec(sql, args)
    end
  end
end
