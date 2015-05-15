class Event < ActiveRecord::Base
  # Host_id represents the organization that created the events and thus the festival the event falls under
  belongs_to :host, class_name: 'User', foreign_key: :host_id
  # Allows commenting
  has_many :comments, as: :commentable
  has_many :event_occurrences
  # Allows having many tags
  has_and_belongs_to_many :tags

  # validates :host_id, presence: true

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    imported = []
    (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        # event = Event.new
        # event.attributes = row.to_hash.slice(*accessible_attributes)
        # event.save!
        row_hash = row.to_hash
        row_hash['dates'] = row_hash['dates'].split(',').map do |date|
            date.strip!
            date = date.split('/').map { |d| d.to_i }
            date[2] += 2000 if date[2] < 2000
            date
        end
        row_hash['times'] = row_hash['times'].split(',').map do |time|
            time.strip!
            t_arr = time.split(/[: ]/)
            if t_arr.length == 1
                t_arr[0] = time[0...time.index(/[apAP]/)].to_i
                t_arr[1] = 0
                t_arr[2] = time[time.index(/[apAP]/)...time.length].upcase
            elsif t_arr.length == 2
                t_arr[2] = t_arr[1][t_arr[1].index(/[apAP]/)...t_arr[1].length].upcase
                t_arr[1] = t_arr[1][0...t_arr[1].index(/[apAP]/)].to_i
                t_arr[0] = t_arr[0].to_i
              else
                t_arr[0] = t_arr[0].to_i
                t_arr[1] = t_arr[1].to_i
            end
            t_arr
        end
        row_hash['locations'] = row_hash['locations'].split(',').map do |l|
            l.strip!
            l
        end
        if row_hash['tags'].present?
          row_hash['tags'] = row_hash['tags'].split(',').map do |tag|
              tag.strip!
              tag.downcase
          end
        else
          row_hash['tags'] = []
        end
        imported << row_hash
    end
    imported
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
        when ".csv" then Roo::CSV.new(file.path)
        when ".xls" then Roo::Excel.new(file.path)
        when ".xlsx" then Roo::Excelx.new(file.path)
        else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
