# frozen_string_literal: true

class Car < ApplicationRecord
  CAR_NUMBER_REGEX = /\A.{2,3}\d{4,6}\z/
  @allowed_fuels = %w(
    P
    ON
    LPG
    EE
  )

  validates :fuel, inclusion: { in: @allowed_fuels }
  validates_format_of :registration_number, with: CAR_NUMBER_REGEX
end
