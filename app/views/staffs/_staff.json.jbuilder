json.witnesses do
  json.array! @witnesses do |witness|
    json.merge! witness.attributes
    json.user witness.user
    json.country_region_city witness.country_region_city
    json.witness_year witness.witness_year
    json.direct_manager_json witness.direct_manager_json
  end
end
json.total_witnesses @total_witnesses