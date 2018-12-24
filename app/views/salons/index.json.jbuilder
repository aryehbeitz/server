#json.array! @salons, partial: 'salons/salon', as: :salon
json.salons do
  json.array! @salons do |salon|
    json.merge! salon.attributes
    json.user salon.user
    json.country_region_city salon.country_region_city
  end
end
json.total_salons @total_salons