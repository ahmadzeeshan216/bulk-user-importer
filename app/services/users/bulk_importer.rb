module Users
  class BulkImporter
    extend ActiveModel::Naming

    attr_reader :csv_path, :errors, :users, :bulk_insert_attributes

    def initialize(path)
      @csv_path = path
      @errors = ActiveModel::Errors.new(self)
      @users = Array.new
      @bulk_insert_attributes = Array.new
    end

    def call
      validate_headers
      return if errors.any?

      CSV.foreach(csv_path, headers: true) do |row|
        attributes = permitted_attributes(row.to_h)
        user = User.new(attributes)

        bulk_insert_attributes.push(attributes) if user.valid?
        users.push(user)
      end

      User.insert_all(bulk_insert_attributes) if bulk_insert_attributes.any?

      true
    end

    private

    def validate_headers
      headers = CSV.foreach(csv_path).first.map(&:to_sym) rescue Array.new

      absent_columns = User::REQUIRED_CSV_COLUMNS - headers

      errors.add(:headers, I18n.t('user.errors.csv_headers')) if absent_columns.any?
    end

    def permitted_attributes(attributes)
      attributes.symbolize_keys.slice(*User::REQUIRED_CSV_COLUMNS)
    end
  end
end
