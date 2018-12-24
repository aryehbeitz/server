
def save_or_get(user)
  u = User.exist?(user.email, user.phone)
  return u if !u.nil?
  user.save!
  return user
end

require "csv"

comments = {}
CSV.foreach('/Users/omer/Dropbox/private/code/Zikaron/zb_comments_dump.csv', :headers => true) do |row|
  comments[row["commentable_id"]] = [] if comments[row["commentable_id"]].nil?
  comments[row['commentable_id']].append({content: row['content'], user_id: row['user_id'].to_i, created_at: row['created_at'], updated_at: row['updated_at']})
end


def fix_email(row)
  if row['email'] && row['email'].match(Devise.email_regexp).nil?
    row['free_text'] = row['free_text'] + " email: " + row['email']
    row['email'] = ""
  end
  row
end

def fix_city(row)
  if CountryRegionCity.where(id: row['city_id']).empty?
    row['free_text'] = row['free_text'] + " city_id: " + row['city_id']
    row['city_id'] = nil
  end
  row
end

def insert_comment(row, witness, comments)
  return if comments[row['id']].nil?
  comments[row['id']].each do |comment|
    comment['entity_id'] = witness.id
    puts comment
    Comment.new(comment).save!
  end
end

Witness.delete_all
Comment.delete_all
index = 0
CSV.foreach('/Users/omer/Dropbox/private/code/Zikaron/zb_witnesses_dump.csv', :headers => true) do |row|
  puts index
  row['free_text'] = '' if row['free_text'].nil?
  puts row['free_text'].nil?
  fix_email(row)

  u = User.new(full_name: row['full_name'], phone: row['phone'],email: row['email'], created_at: row['created_at'], updated_at: row['updated_at'])
  puts u.id
  u = save_or_get(u)

  fix_city(row)
  w = Witness.new(user_id: u.id, address: row['address'], country_region_city_id: row['city_id'], witness_type: row['witness_type'], language: row['language'], stairs: row['stairs'], special_needs: row['special_needs'], seminar_required: row['seminar_required'], free_text: row['free_text'], special_population: row['special_population'], created_at: row['created_at'], updated_at: row['updated_at'], contact_name: row['contact_name'], contact_phone: row['contact_phone'], additional_phone: row['additional_phone'], archived: row['archived'])

  begin
  w.save!
  insert_comment(row,w, comments)
  rescue => e
    puts w.to_json
    puts e
  end

  index += 1
end


#staff
#Staff.delete_all
#CSV.foreach('/Users/omer/Dropbox/private/code/Zikaron/zb_managers_emails_dump.csv', :headers => true) do |row|
#  user = User.where(email: row['temp_email']).first
#  if user.nil?
#    puts row['temp_email']
#  else
#    Staff.new(user_id: user.id, entity_type:'old').save!
#  end
#end