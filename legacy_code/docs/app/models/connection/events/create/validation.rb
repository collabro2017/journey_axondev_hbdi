class Connection
  module Events
    class Create
      class Validation
        include ActiveModel
        include ActiveModel::Validations

        attr_reader :invited_email_address

        validates :invited_email_address, format: /@/

        def initialize(params)
          @invited_email_address = params[:invited_email_address]
        end
      end
    end
  end
end
