class TemplatesController < ApplicationController
  unloadable
  menu_item :settings
  model_object WikiTemplates
  before_action :find_project, :authorize, only: [:new, :edit, :destroy]

  def index
    # Add logic for displaying templates or redirect as needed
  end

  def create
    if request.post?
      @mitemplate = WikiTemplates.new(template_params)
      @mitemplate.author_id = User.current.id
      @mitemplate.project_id = @project_id

      if @mitemplate.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to project_settings_path(@project, tab: 'template')
      else
        render action: 'new'
      end
    else
      @mitemplate = WikiTemplates.new
    end
  end

  def destroy
    @mitemplate = WikiTemplates.find(params[:id])

    if @mitemplate
      @mitemplate.destroy
      flash[:notice] = l(:label_template_delete)
    end

    redirect_to project_settings_path(@project, tab: 'template')
  end

def edit
  if request.patch?
    # Handle the form submission to update the template
    @mitemplate = WikiTemplates.find(params[:id])
    @mitemplate.attributes = template_params
    @mitemplate.project_id = @project_id

    if @mitemplate.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_settings_path(@project, tab: 'template')
    else
      render action: 'edit'
    end
  else
    # Render the edit form
    @mitemplate = WikiTemplates.find(params[:id])
  end
end

  private

  def template_params
    params.require(:mitemplate).permit(:name, :text, :visible_children)
  end

  def find_project
    @project = Project.find(params[:project_id])
    @project_id = params[:project_id] # Consider whether this is necessary
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end

