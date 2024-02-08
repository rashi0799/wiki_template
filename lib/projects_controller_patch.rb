# lib/projects_controller_patch.rb
module ProjectsControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method :settings, :settings_with_template
    end
  end

  module InstanceMethods
    def settings_with_template
      @issue_custom_fields = IssueCustomField.order(position: :asc)
      @issue_category ||= IssueCategory.new
      @member ||= @project.members.new
      @trackers = Tracker.all
      @wiki ||= @project.wiki
      @project_id = @project.id
      @templates = WikiTemplates.where(project_id: @project_id)
    end
  end
end

