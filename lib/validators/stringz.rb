class StringzValidator < ActiveModel::EachValidator
    def self.null_char_with_trailing_char_regex
      /\0[^\0]/
    end

    def validate_each(record, attribute, value)
        if value
            bad_null = value.match StringzValidator.null_char_with_trailing_char_regex
            if bad_null
                record.errors[attribute] = "Attribute #{attribute} has a null terminator in the middle of the string. Sent messages will parse wrong"
            end
        end
    end
end
