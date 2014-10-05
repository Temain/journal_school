module HistoryHelper

  def event_subtext(journal_record)
    event = journal_record.journalable
    content_tag(:div, class: "block") do
      if event.instance_of?(Relocation)
        content_tag(:div) do
          "Перемещен из подразделения \"#{event.old_department.name}\"
                    в подразделение \"#{event.new_department.name}\""
        end
      else
        content_tag(:div, event.reason) +
        (event.spares.empty? ? "Необходимости в замене деталей не было." : content_tag(:div, "Список замененных деталей: ")) +
        content_tag(:ul) do
          event.spares.map { |item| content_tag(:li, item.name) }.join(' ').html_safe
        end
      end
    end
  end

end
