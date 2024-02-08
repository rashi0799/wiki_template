module WikiControllerPatch
  def self.prepended(base)
    base.prepend(InstanceMethods)
    base.alias_method :edit_without_template, :edit
    base.alias_method :edit, :edit_with_template
    base.alias_method :show_without_template, :show
    base.alias_method :show, :show_with_template
    base.alias_method :preview_without_template, :preview
    base.alias_method :preview, :preview_with_template
  end

  module InstanceMethods
    def edit_with_template
      return render_403 unless editable?
      select_elige_plantilla = '0'
      
      if params[:issue_plantilla]
        select_elige_plantilla = params[:issue_plantilla]
      end

      # If the user select a template he could create a page with it
      if @page.new_record?
        @page.content = WikiContent.new(page: @page)
        if params[:parent].present?
          @page.parent = @page.wiki.find_page(params[:parent].to_s)
        end
      end

      @content = @page.content_for_version(params[:version])
      
      case select_elige_plantilla
      when '0'
        @content.text = initial_page_content(@page) if @content.text.blank?
      else
        miwiki = WikiTemplates.find(select_elige_plantilla)
        @content.text = miwiki.text unless miwiki.nil?
      end

      # don't keep previous comment
      @content.comments = nil

      # To prevent StaleObjectError exception when reverting to a previous version
      @content.version = @page.content.version

      @text = @content.text
      if params[:section].present? && Redmine::WikiFormatting.supports_section_edit?
        @section = params[:section].to_i
        @text, @section_hash = Redmine::WikiFormatting.formatter.new(@text).get_section(@section)
        render_404 if @text.blank?
      end
      render 'my_edit'
    end

    def preview_with_template
      # If the user choose a template he will see the preview of it
      if params[:issue_plantilla]
        select_elige_plantilla = params[:issue_plantilla]

        if select_elige_plantilla != '0'
          miwiki = WikiTemplates.find(select_elige_plantilla)
          @text = miwiki.text unless miwiki.nil?
        else
          @text = ''
        end
        # If the user doesn't choose a template he will see the preview of a page
      else
        page = @wiki.find_page(params[:id])
        # page is nil when previewing a new page
        return render_403 unless page.nil? || editable?(page)

        if page
          @attachements = page.attachments
          @previewed = page.content
        end
        @text = params[:content][:text]
      end
      render partial: 'common/preview'
    end
  end
end

