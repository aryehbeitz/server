class WitnessYear < ApplicationRecord

  belongs_to :witness

  validates :witness, uniqueness: { scope: :year,
                                    message: "should happen once per year" }

  def ready_for_salon
    return self.first_staff_contacted
  end
end
