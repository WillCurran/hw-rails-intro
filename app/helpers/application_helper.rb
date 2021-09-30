module ApplicationHelper
    def sort_helper text, col_name
        # TODO - run text through escaper to mitigate SQL injection?
        dir = 'asc'
        if params[:active_col] == col_name and params[:sort_dir] == 'asc'
            dir = 'desc'
        end
        link_to text, :active_col => col_name, :sort_dir => dir
    end
end
