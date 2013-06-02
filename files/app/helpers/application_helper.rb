module ApplicationHelper

  # Creates link for sorting columns
  def sortable(column, title = nil)  
    title ||= column.titleize  
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"  
    link_to title, sort: column, direction: direction, search: params[:search], page: params[:page]
  end
  
end
