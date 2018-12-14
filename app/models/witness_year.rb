class WitnessYear < ApplicationRecord

  belongs_to :witness

  validates :witness, uniqueness: { scope: :year,
                                    message: "should happen once per year" }
end
