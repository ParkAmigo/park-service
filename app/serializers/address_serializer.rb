class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address_line_first, :address_line_second, :pin_code
end
