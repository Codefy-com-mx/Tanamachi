{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}

{% if settings.pagination == 'infinite' %}
	{% paginate by 12 %}
{% else %}
	{% paginate by 24 %}
{% endif %}

{% if not show_help %}

{% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}

<div class="container">
	<div class="d-flex flex-wrap align-items-baseline mb-2">
		<div class="mr-3">
			{% embed "snipplets/page-header.tpl" with {container: false, padding: false, show_breadcrumbs: false, page_header_text_alignment: 'text-left', page_header_title_class: 'text-35px mb-0 font-weight-bold'} %}
				{% block page_header_text %}{{ category.name }}{% endblock page_header_text %}
			{% endembed %}
		</div>
		<div class="mt-2">
			{% if products %}
				<a href="#" class="js-modal-open btn-link text-35px font-weight-bold" data-toggle="#nav-filters" data-component="filter-button">
					{% if has_filters_available %}
						{{ "Filtrar" | translate }}
					{% else %}
						{{ "Ordenar" | translate }}
					{% endif %}
				</a>
			{% endif %}
		</div>
	</div>
	{% if category_banner %}
	    {% include 'snipplets/category-banner.tpl' %}
	{% endif %}
	{% if category.description %}
		<p class="mt-2 mb-4 text-left">{{ category.description }}</p>
	{% endif %}
</div>

{# Modals for filters #}
{% include 'snipplets/grid/filters-modals.tpl' with {show_filter_button: false} %}
<section class="js-category-controls-prev category-controls-sticky-detector"></section>

<section class="category-body" data-store="category-grid-{{ category.id }}">
	<div class="container-fluid px-0 mt-4 mb-5">
		<div data-store="category-grid-{{ category.id }}">
			{% include 'snipplets/grid/product-list.tpl' %}
		</div>
	</div>
</section>
{% elseif show_help %}
	{# Category Placeholder #}
	{% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}