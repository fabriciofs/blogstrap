class ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update show destroy]

  def index
    @highlights = Article.desc_order.first(3)
    highlight_ids = @highlights.pluck(:id).join(',')

    current_page = (params[:page] || 1).to_i
    @articles = Article
        .without_highlights(highlight_ids)
        .desc_order
        .page(current_page)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      flash[:alert] = 'Something went wrong'
      render :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      flash[:alert] = 'Something went wrong'
      render :new
    end
  end

  def destroy
    if @article.destroy
      redirect_to articles_url, notice: 'Article was successfully deleted.'
    else
      redirect_to articles_url, alert: 'Something went wrong'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
