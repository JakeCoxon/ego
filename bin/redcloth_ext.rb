module RedCloth::Formatters::HTML
  def code(opts)
    opts[:block] = true
    "<code#{pba(opts)}>#{fix_code(opts[:text])}</code>"
  end

  def fig(opts)
    match = opts[:text].match(/^(?:(?<label>.+)\s*\|\s*)?(?<img>.+)$/)
    label_span = "\n<span>#{match[:label]}</span>" if match[:label]
    %Q{<div class="image">
        <img src="#{match[:img]}" /> #{label_span}
      </div>}
  end

  private

  def fix_code(text)
    text.gsub(/^\n/, '').gsub(/\t/, '  ')
  end
end