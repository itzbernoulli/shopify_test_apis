class Customer < ApplicationRecord
  belongs_to :user

  def self.insert_all(records, user_id)
    normalized = normalize(records, user_id)
    super(normalized)
  end
  def self.normalize(records, user_id)
    records.each do |rec|
      rec['user_id'] = user_id
      add_timestamp(rec)
    end
  end
  def self.add_timestamp(record)
    time = Time.now.utc
    record['created_at'] = time
    record['updated_at'] = time
  end
end
