class StringzValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        if value
            null_instances = value.grep(/\0/)
            if null_instances.size > 0
                record.errors[attribute] = "Attribute #{attribute} has a null terminator in the middle of the string. Sent messages will parse wrong"
            end
        end
    end
end

