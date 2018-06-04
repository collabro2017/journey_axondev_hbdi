require 'active_record/connection_adapters/postgresql_adapter'

module FixReferentialIntegrityHandling

  def disable_referential_integrity(&block)
    if supports_disable_referential_integrity?
      disable_referential_integrity_with_disable_trigger(&block)
    else
      yield
    end
  end

end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :include, FixReferentialIntegrityHandling
