class Int8Validator < ActiveModel::EachValidator
    MinValue = -128
    MaxValue = 127

    def validate_each(record, attribute, value)
        if value
            record.errors[attribute] = "Attribute #{attribute} has a value out of bounds: #{value}" unless
                MinValue <= value and value <= MaxValue
        end
    end
end

