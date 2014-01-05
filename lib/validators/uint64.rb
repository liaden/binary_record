class Uint64Validator < ActiveModel::EachValidator
    MinValue = 0
    MaxValue = 2 ** 64 - 1

    def validate_each(record, attribute, value)
        if value
            record.errors[attribute] = "Attribute #{attribute} has a value out of bounds: #{value}" unless
                MinValue <= value and value <= MaxValue
        end
    end
end


