class ConnectionEvent
  module Events
    class Create
      class Validation
        include ActiveModel
        include ActiveModel::Validations

        attr_reader :initiated_by, :connection

        validate :validate_is_authorized

        def initialize(params)
          @initiated_by = params[:initiated_by]
          @connection = params[:connection]
          @authorized = false
        end

        def authorized?
          @authorized
        end

        private
        def validate_is_authorized
          if initiated_by == connection.target
            @authorized = true
          else
            errors.add(:authorized?, :unauthorized)
            @authorized = false
          end
        end
      end
    end
  end
end
