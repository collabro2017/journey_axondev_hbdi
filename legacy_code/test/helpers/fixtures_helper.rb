module FixturesHelper

  # Public: generates a stable uuid from a given string
  #
  # label - string to hash to create the uuid
  def uuid(label)
    UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE, label)
  end
end

ActiveRecord::FixtureSet.context_class.send :include, FixturesHelper
