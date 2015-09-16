#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == ActiveAdmin helper
  #
  module ActiveAdminHelper
    def edit_heading_page_aa
      category = Category.find_by(name: controller_name.classify)
      link_to t('active_admin.action_item.edit_heading_page', page: category.menu_title), edit_admin_category_path(category)
    end
  end
end