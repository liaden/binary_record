class Int16Validator < ActiveModel::EachValidator
    MinValue = -1*2**15
    MaxValue = 2**15-1

    def validate_each(record, attribute, value)
        if value
            record.errors[attribute] = "Attribute #{attribute} has a value out of bounds: #{value}" unless
                MinValue <= value and value <= MaxValue
        end
    end
end


