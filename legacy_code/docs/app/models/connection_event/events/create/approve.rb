class ConnectionEvent
  module Events
    class Create
      class Approve
        attr_reader :params

        def initialize(params)
          @params = params
        end

        def handle
          result = nil
          ConnectionEvent.transaction do
            result = ConnectionEvent.create(
              event: 'approved',
              initiated_by: params[:initiated_by],
              connection: connection
            )
            connection.status = 'approved'
            connection.save!
          end
          {result: result}
        end

        def validate
          @validation ||= begin
            validation = ConnectionEvent::Events::Create::Validation.new(params)
            validation.validate
            validation
          end
        end

        private
        def connection
          @connection ||= params[:connection]
        end
      end
    end
  end
end
