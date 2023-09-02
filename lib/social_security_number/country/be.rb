module SocialSecurityNumber
  # SocialSecurityNumber::Be validates Belgium National Register Number (Rijksregisternummer)
  # https://en.wikipedia.org/wiki/National_identification_number#Belgium
  class Be < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !(1..997).member?(@individual.to_i)
                 'individual number is invalid'
               elsif !birth_date && @month.to_i != 0 && @day.to_i != 0
                 'number birth date is invalid'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    def gender
      @gender = @individual.to_i.odd? ? :male : :female
    end

    private

    REGEXP = /^(?<year>\d{2})[- .]?(?<month>\d{2})[- .]?(?<day>\d{2})[- .]?(?<indv>\d{3})[- .]?(?<ctrl>\d{2})$/

    def check_control_sum
      count_last_number == @control_number.to_i || count_last_number('2') == @control_number.to_i
    end

    def count_last_number(number = '0')
      97 - (("#{number}#{value_from_parsed_civil_number('year')}#{value_from_parsed_civil_number('month')}#{value_from_parsed_civil_number('day')}#{value_from_parsed_civil_number('indv')}").to_i % 97)
    end
  end
end
