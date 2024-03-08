class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  after_action :broadcast_projects, only: %i[create update destroy]

  def index
    @projects = Project.all
  end

  def show
    @tasks = @project.tasks.order(id: :desc)
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.create!(project_params)
    redirect_to(project_url(@project), notice: "Project was successfully created.")
  end

  def update
    @project.update(project_params)

    redirect_to(project_url(@project), notice: "Project was successfully updated.")
  end

  def destroy
    @project.destroy!

    redirect_to(projects_url, notice: "Project was successfully destroyed.")
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def broadcast_projects
    Turbo::StreamsChannel.broadcast_refresh_to("projects_broadcaster")
  end

end
