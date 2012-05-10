module RedCloth::Formatters::HTML
  def code(opts)
    opts[:block] = true
    "<code#{pba(opts)}>#{fix_code(opts[:text])}</code>"
  end

  def fig(opts)
    opts[:text].match(/^(?:(.+)\s*\|\s*)?(.+)$/)
    label = $1
    img = $2
    label_span = "<span>#{label}</span>" if label
    <<-HTML
      <div class="image">
        <img src="#{img}" />
        #{label_span}
      </div>
    HTML
  end


  private

  def fix_code(text)
    text.gsub(/^\n/, '').gsub(/\t/, '  ')
  end
end