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
      # binding.pry
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

  end
end