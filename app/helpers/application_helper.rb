module ApplicationHelper
  def sidebar_link(label, path, active: false)
    classes = if active
      "block px-4 py-2 rounded-md text-sm font-medium text-teal-400 bg-teal-600/15"
    else
      "block px-4 py-2 rounded-md text-sm text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition-colors"
    end

    link_to label, path, class: classes
  end

  def user_signed_in?
    Current.user.present?
  end

  def page_header(title, &block)
    content_tag(:div, class: "flex items-center justify-between mb-6") do
      content_tag(:h1, title, class: "font-['Satoshi',system-ui,sans-serif] font-bold text-2xl tracking-tight") +
        (block ? capture(&block) : "".html_safe)
    end
  end

  def btn_primary(label, path, method: :get, **opts)
    if method == :get
      link_to label, path, class: "inline-flex items-center px-4 py-2.5 rounded-md text-sm font-medium text-white bg-teal-600 hover:bg-teal-700 transition-colors #{opts[:class]}"
    else
      button_to label, path, method: method, class: "inline-flex items-center px-4 py-2.5 rounded-md text-sm font-medium text-white bg-teal-600 hover:bg-teal-700 transition-colors #{opts[:class]}"
    end
  end

  def btn_secondary(label, path, **opts)
    link_to label, path, class: "inline-flex items-center px-4 py-2.5 rounded-md text-sm font-medium text-slate-700 border border-slate-300 hover:bg-slate-100 transition-colors #{opts[:class]}"
  end

  def mono(text)
    content_tag(:span, text, class: "font-['JetBrains_Mono',monospace] tabular-nums")
  end
end
