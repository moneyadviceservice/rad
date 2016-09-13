class Array
  def to_html(list = 'li')
    return nil if self.empty?
    ["<#{list}>",
     self.map { |e| "<li>#{e}</li>" }, # rubocop:disable all
     "</#{list}>"
    ].join("\n")
  end
end
