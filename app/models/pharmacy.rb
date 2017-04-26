class Pharmacy < Provider

  def self.default_scope
    where is_pharmacy: true
  end

end
