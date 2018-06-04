class Connection
  module Events
    class Create
      include QueBus::Publisher
      extend ActiveModelSerializers::Deserialization

      attr_reader :params

      def self.from_jsonapi(params, context)
        attributes = jsonapi_parse(params, only: ['invited-email-address'])
        new(attributes.merge(initiating_user: context.current_user))
      end

      def initialize(params)
        @params = params
      end

      def handle
        validation = validate
        result = nil
        if validation.errors.empty?
          result = create_connection
          publish *connection_request_created_event
        end
        {validation: validation, result: result, effects: {events: messages}}
      end

      def validate
        @validation ||= begin
          validation = Validation.new(params)
          validation.validate
          validation
        end
      end

      private

      def create_connection
        Connection.transaction do
          attributes = params.except(:initiating_user).merge(status: 'pending')
          connection = Connection.create(attributes)

          if invited_member
            ConnectionMember.create(
              connection: connection,
              member: invited_member)
          end
          ConnectionMember.create(
            connection: connection,
            member: params[:initiating_user])

          connection.reload
          connection
        end
      end

      def invited_member
        @invited_member ||= Thinker.find_by(
                          email: params[:invited_email_address])
      end

      def connection_request_created_event
        [
          :connection_request_created,
          {
            initiated_by: {
              id: params[:initiating_user].uuid,
              type: 'thinker'
            },
            target: target_data
          }
        ]
      end

      def target_data
        if invited_member
          {
            email: params[:invited_email_address],
            known_thinker: true,
            id:invited_member.uuid
          }
        else
          {
            email: params[:invited_email_address],
            known_thinker: false,
          }
        end
      end
    end
  end
end
