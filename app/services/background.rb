module Background
  extend self

  cattr_writer :mode

  def mode
    @@mode || :inline
  end

  def go(&blk)
    fn = backgroundable(&blk)

    case mode
    when :threads
      Thread.new { fn.call }
    when :inline
      fn.call
    else
      raise "invalid mode #{mode}"
    end
  end

  private

  def backgroundable(&blk)
    Proc.new do
      ActiveRecord::Base.connection_pool.with_connection do
        ActiveRecord::Base.transaction do
          blk.call
        end
      end
    end
  end
end
