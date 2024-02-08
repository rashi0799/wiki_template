class TemplatesController < ApplicationController
  unloadable
  menu_item :settings
  model_object WikiTemplates
  before_action :find_project, :authorize, only: [:new, :edit, :destroy]

  def index
    @project_templates = WikiTemplates.where(project_id: @project.id)
   end

  def new
    @project_id = params[:project_id]
    if request.post?
      @mitemplate = WikiTemplates.new(template_params)
      @mitemplate.author_id = User.current.id
      @mitemplate.project_id = @project.id

      if @mitemplate.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to project_templates_path(@project)
      else
        render action: 'new'
      end
    else
      @mitemplate = WikiTemplates.new
    end
  end

def create
  if request.post?
    @mitemplate = WikiTemplates.new(template_params)
    @mitemplate.author_id = User.current.id
    @mitemplate.project_id = @project_id

    if @mitemplate.save
      flash[:notice] = l(:notice_successful_create)

      # Check if a template is selected and handle it
      if params[:use_template] == '1' && params[:template_id].present?
        # Find the selected template
        selected_template = WikiTemplates.find(params[:template_id])

        # Create a new wiki page using the selected template
        @wiki_page = WikiPage.new(
          project_id: @mitemplate.project_id, # Set the correct project_id
          title: @mitemplate.name,
          text: selected_template.text
        )

        if @wiki_page.save
          flash[:notice] = l(:notice_successful_create)
          redirect_to controller: 'wiki', action: 'show', id: @wiki_page.title, project_id: @wiki_page.project_id
        else
          render action: 'new'
        end
      else
        redirect_to action: 'index'
      end
    else
      render action: 'new'
    end
  else
    @mitemplate = WikiTemplates.new
  end
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
    rescue ActiveRecord::RecordNotFound
    render_404
  end
end

