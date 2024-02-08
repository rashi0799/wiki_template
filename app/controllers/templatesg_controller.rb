class TemplatesgController < ApplicationController
  unloadable
  model_object WikiTemplatesg
  layout 'admin'
  
  before_action :require_admin

  def index
    @templates = WikiTemplatesg.all
    render action: "index", layout: false if request.xhr?
  end

  def new
    if request.post?
      @mitemplate = WikiTemplatesg.new(template_params)
      @mitemplate.author_id = User.current.id
      if @mitemplate.save
        flash[:notice] = l(:notice_successful_create)

        # Check if a template is selected and handle it
        if params[:use_template] == '1' && params[:template_id].present?
          # Find the selected template
          selected_template = WikiTemplatesg.find(params[:template_id])

          # Create a new wiki page using the selected template
          @wiki_page = WikiPage.new(
            project_id: @mitemplate.project_id,  # Make sure to set the correct project_id
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
      @mitemplate = WikiTemplatesg.new
    end
  end

  def destroy
    @mitemplate = WikiTemplatesg.find(params[:id])
    if @mitemplate
      @mitemplate.destroy
      flash[:notice] = l(:label_template_delete)
    end
    redirect_to action: 'index'
  end

def edit
  if request.patch?
    @mitemplate = WikiTemplatesg.find(params[:id])
    if @mitemplate.update(template_params)
      flash[:notice] = l(:notice_successful_update)
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  else
    @mitemplate = WikiTemplatesg.find(params[:id])
  end
end

def update
  @mitemplate = WikiTemplatesg.find(params[:id])
  if @mitemplate.update(template_params)
    flash[:notice] = l(:notice_successful_update)
    redirect_to action: 'index'
  else
    render action: 'edit'
  end
end
def create
  @mitemplate = WikiTemplatesg.new(template_params)

  if @mitemplate.save
    flash[:notice] = l(:notice_successful_create)

    # Check if a template is selected and handle it
    if params[:use_template] == '1' && params[:template_id].present?
      # Find the selected template
      selected_template = WikiTemplatesg.find(params[:template_id])

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
end
  private

  def template_params
    params.require(:mitemplate).permit(:name, :text, :visible_children, :project_id)
  end
end

