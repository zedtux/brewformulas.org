class Hash
  def full_messages
    self.map { |key, value| "#{key} #{value}" }.to_sentence
  end
end
