module FlactiveRecord
  class Base
    attr_accessor :id, :language, :name

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
      column_names = []
      self.exec(sql).each do |column|
        column_names << column["column_name"]
      end
      column_names
    end

    def initialize(hash={})
      hash.each do |property, value|
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

    def self.all
      sql = <<-SQL
        SELECT *
        FROM #{table_name}
      SQL
      results = DBConnection.instance.exec(sql)
      items = []
      results.each do |person|
        items << self.new(person)
      end
      items
    end

    def self.find(id)
      sql = <<-SQL
        SELECT *
        FROM #{table_name}
        WHERE id=$1
        LIMIT 1
      SQL
      results = DBConnection.instance.exec(sql, [id])
      results.map do |row|
          new row
      end.first
    end

    def self.insert
    end


  end
end