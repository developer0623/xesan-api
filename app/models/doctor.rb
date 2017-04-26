class Doctor < Provider

  def self.default_scope
    where is_pharmacy: false, entity_type_code: 1
  end

end
