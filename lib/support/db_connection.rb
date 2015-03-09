require 'singleton'
class DBConnection
  attr_reader :dbname
  include Singleton

  def exec(sql, args=[])
    connection.exec_params(sql, args)
  end

  def dbname=(new_dbname)
    @dbname = new_dbname
    @connection = PG.connect(dbname: dbname, host: 'localhost')
  end

  def connection
    @connection ||= PG.connect(dbname: dbname, host: 'localhost')
  end
end
