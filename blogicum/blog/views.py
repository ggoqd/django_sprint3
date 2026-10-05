from django.shortcuts import get_object_or_404, render
from django.utils import timezone

from .models import Category, Post


def get_public_posts(queryset=None):
    """Посты, готовые к показу: опубликованный пост, опубликованная
    категория и наступившая дата публикации.
    """
    if queryset is None:
        queryset = Post.objects.all()
    return queryset.filter(
        category__is_published=True,
        is_published=True,
        pub_date__lte=timezone.now(),
    ).select_related('author', 'category', 'location')


def index(request):
    post_list = get_public_posts()[:5]
    context = {'post_list': post_list}
    return render(request, 'blog/index.html', context)


def category_posts(request, slug):
    category = get_object_or_404(Category, slug=slug, is_published=True)
    post_list = get_public_posts(category.posts.all())
    context = {'category': category, 'post_list': post_list}
    return render(request, 'blog/category.html', context)


def post_detail(request, pk):
    post = get_object_or_404(get_public_posts(), pk=pk)
    context = {'post': post}
    return render(request, 'blog/detail.html', context)
