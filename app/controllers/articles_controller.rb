class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search]
      @articles = Article.where("title ILIKE ? OR content ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @articles = Article.all
      @articles = Article.page(params[:page]).per(5)
    end
  end

  def show
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Article not found."
    redirect_to articles_path
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

    def article_params
      params.require(:article).permit(:title, :content)
    end

    def set_article
      @article = Article.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Article not found."
      redirect_to articles_path
    end
end
